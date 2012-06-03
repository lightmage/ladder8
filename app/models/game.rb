require 'graph'
require 'replay'
require 'timeout'

class Game < ActiveRecord::Base
  attr_accessible :chat, :era, :map, :rby, :replay, :title, :turns, :version
  attr_accessor   :game, :replay_nodes
  attr_readonly   :replay

  belongs_to :map
  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :losers,   :through => :teams, :source => :sides, :conditions => {'teams.won' => false}
  has_many :players,  :through => :sides
  has_many :sides,    :through => :teams
  has_many :teams,    :dependent => :destroy
  has_many :winners,  :through => :teams, :source => :sides, :conditions => {'teams.won' => true}

  default_scope order('games.updated_at DESC')
  scope :confirmed,   where('games.confirmed_cache = ?', true)
  scope :old,         lambda {where 'games.created_at < ?', Ladder8::Application.config.auto_delete.days.ago}
  scope :since,       lambda {|time| where 'games.created_at >= ?', time.days.ago}
  scope :unconfirmed, where('games.confirmed_cache = ?', false)

  VALID_ERAS = ['Era Default']
  #VALID_ERAS = ['Era Default', 'RBY No Mirror']

  validate_on_create  :replay_is_unique, :replay_isnt_rmp, :sides_size_equals_players_size
  validates :era,     :inclusion  => {:in => VALID_ERAS}
  validates :replay,  :format => {:on => :create, :with => %r(http://replays\.wesnoth\.org/\d+\.\d+/\d{8}/.+\.gz)}
  validates :version, :format => {:with => %r(\d+.\d+)}
  validates_presence_of :era, :replay, :title, :turns, :version

  def chat_entries
    entries = YAML.load chat

    entries.each {|e| e[0] = player_hash[e.first] if player_hash.key? e.first}
    entries.map  {|e| {:speaker => e.first, :message => e.second, :obs => e.third}}
  end

  def feed_body
    sides.collect do |side|
      side.to_s
    end.join ' & '
  end

  def feed_title
    to_s
  end

  def player_ids
    @player_ids ||= players.pluck 'players.id'
  end

  def public_errors
    errors[:game]
  end

  def sides_confirmed?
    sides.confirmed.count == sides.count
  end

  def to_param
    "#{id} #{title}".parameterize
  end

  def to_s
    @to_s ||= "#{map.name} Turn #{turns}"
  end

  def update_ratings
    ts_graph = Graph.new ts_teams, ts_results
    ts_graph.update_skills

    ts_graph.teams.flatten.each {|r| r.apply}
  end

  def winner= player
    side = sides.where(:player_id => player.id).first!
    team = side.team

    team.sides.all.each {|s| s.update_attribute :confirmed, true}
    team.update_attribute :won, true
  rescue
    raise SecurityError
  end

  private

  def player_hash
    @player_map ||= players.inject(Hash.new) do |hash, player|
      hash[player.nick] = player
      hash
    end
  end

  def replay_is_unique
    if Game.find_by_confirmed_cache_and_replay true, replay
      errors.add :game, 'was already reported'
    end
  end

  def replay_isnt_rmp
    if new_record? and replay_nodes.try :rmp? and Ladder8::Application.config.ban_rmp
      errors.add :game, 'was played using RMP'
    end
  end

  def sides_size_equals_players_size
    unless players.size == sides.size
      errors.add :game, 'has invalid number of players'
    end
  end

  def ts_results
    ts_results = Array.new ts_teams.size - 1, 2
    ts_results.unshift 1
    ts_results
  end

  def ts_teams
    @ts_teams ||= begin
      winner = teams.winner.first.ts_team
      losers = teams.losers.map {|t| t.ts_team}

      [winner, *losers]
    end
  end

  class << self
    def has_confirmed? link
      !!(find_by_confirmed_cache_and_replay true, link)
    end

    def report player, url
      url.strip!

      begin
        raise if url.blank?

        Timeout.timeout(9) do
          replay = Replay.load url
          game   = build_from replay
          game.replay_nodes = replay

          Game.transaction do
            game.save
            unless game.valid?
              raise ActiveRecord::Rollback, 'invalid game'
            end
            game.winner = player
          end

          game
        end
      rescue ActiveRecord::RecordNotFound
        return_invalid :game, 'was played by unregistered players'
      rescue ArgumentError
        return_invalid :game, 'was played on unallowed map'
      rescue SecurityError
        return_invalid :game, "wasn't not played by you"
      rescue StandardError, TimeoutError
        return_invalid :game, 'could not be retrieved (check replay link and try again)'
      end
    end

    def search params
      chain  = self.confirmed.joins :map, {:sides => [:team, :player]}

      if params[:players] and not params[:players].empty?
        chain = chain.where 'players.nick_parameterized' => params[:players].collect {|p| p.downcase}
      end
      if params[:factions] and not params[:factions].empty?
        chain = chain.where 'sides.faction' => params[:factions].collect {|f| f.downcase.titleize}
      end
      if params[:leaders] and not params[:leaders].empty?
        chain = chain.where 'sides.leader' => params[:leaders].collect {|l| l.downcase.titleize}
      end
      if params[:maps] and not params[:maps].empty?
        chain = chain.where 'maps.name_parameterized' => params[:maps].collect {|m| Map.parameterized_name m}
      end

      chain.group(column_list)
    end

    private

    def build_from replay 
      game = Game.new replay.processed_info

      replay.teams_with_processed_sides.each do |name, sides|
        game.teams.build(:name => name).sides.build sides
      end

      game
    end

    def return_invalid field, message
      game = Game.new
      game.errors.add field.to_sym, message
      game
    end
  end
end
