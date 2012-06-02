require 'rating'

class Player < ActiveRecord::Base
  attr_accessible :admin, :banned, :as => :admin
  attr_accessible :avatar, :background, :color, :country, :description, :import_rating, :nick, :password, :password_confirmation, :signature, :submited_code, :timezone, :as => [:admin, :default]
  attr_accessor :import_rating, :submited_code, :valid_code
  attr_readonly :nick, :nick_parameterized, :deviation_initial, :mean_initial

  before_save :set_rating
  before_validation :parameterize_nick

  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :games,    :through => :teams
  has_many :news,     :dependent => :destroy
  has_many :sides
  has_many :teams,    :through => :sides

  has_secure_password

  scope :admins, where(:admin => true).reorder(:nick)
  scope :before, lambda {|player| where 'rating > ? AND nick <> ?', player.rating, player.nick}
  scope :default_order, order('players.rating DESC, players.nick_parameterized')
  scope :from_country, lambda {|country| where :country => country}
  scope :newcomers, limit(6).reorder('id DESC')
  scope :ranked, group(column_list).joins(:games).where('players.banned = ? AND games.confirmed_cache = ?', false, true)
  default_scope default_order

  self.per_page = 100

  VALID_NICK = /^[a-z0-9][a-z0-9\-\_]*$/i

  validate :verify_avatar, :verify_background, :verify_code
  validates :color,       :inclusion => {:allow_blank => true, :in => Color.all}
  validates :country,     :inclusion => {:in => Country.codes}
  validates :description, :length => {:allow_blank => true, :maximum => 800}
  validates :nick,        :format => {:with => VALID_NICK}, :uniqueness => {:case_sensitive => false}
  validates :password,    :length => {:allow_blank => true, :in => 6..24}
  validates :signature,   :length => {:allow_blank => true, :maximum => 200}
  validates :timezone,    :inclusion => {:in => ActiveSupport::TimeZone.zones_map.keys, :message => 'is required'}

  def authorized_to_confirm? side
    admin? or self == side.player
  end

  def avatar_filename
    Background.filename avatar if avatar?
  end

  def background_filename
    Background.filename background if background?
  end

  def can_modify_player? player_id
    admin? or id == player_id
  end

  def country_filename
    Country.filename country if country?
  end

  def country_rank
    if ranked?
      Player.ranked.where(:country => country).before(self).count.size + 1
    end
  end

  def comments?
    not comments.empty?
  end

  def has_comments_since? time
    time and comments? and comments.first.created_at > time
  end

  def initial_rating
    Rating.new mean_initial, deviation_initial
  end

  def local_time time
    time.to_time.in_time_zone timezone
  end

  def general_rank
    if ranked?
      Player.ranked.before(self).count.size + 1
    end
  end

  def ranked?
    not games.confirmed.size.zero?
  end

  def role
    :admin if admin?
  end

  def to_param
    "#{id} #{nick}".parameterize
  end

  def to_s
    nick
  end

  def ts_rating
    rating = Rating.new mean, deviation
    rating.player = self
    rating
  end

  private

  def parameterize_nick
    self.nick_parameterized = nick.downcase
  end

  def set_mean_and_deviation
    perform_import = import_rating.to_i == 1

    if perform_import
      imports = YAML.load File.read(Rails.root.join 'db', 'imports.yml')
      player  = imports[nick]
    end

    if perform_import and player
      starting_mean      = player[:mean]
      starting_deviation = player[:deviation]
    else
      starting_mean      = 25.0
      starting_deviation = starting_mean / 3
    end

    self.mean      = self.mean_initial      = starting_mean
    self.deviation = self.deviation_initial = starting_deviation
  end

  def set_rating
    set_mean_and_deviation if new_record?
    self.rating = ts_rating.to_f
  end

  def verify_avatar
    if (not Avatar.valid? avatar) or (not Avatar.exists? avatar)
      errors.add :avatar, 'is required'
    end
  end

  def verify_background
    if background?
      if (not Background.valid? background) or (not Background.exists? background)
        errors.add :background, 'is invalid'
      end
    end
  end

  def verify_code
    if new_record? and Ladder8::Application.config.validate_code
      errors.add(:submited_code, 'is invalid') unless submited_code == valid_code
    end
  end

  class << self
    def login! nick, pass
      player = Player.find_by_nick_parameterized nick.strip.downcase

      raise SecurityError, "nick doesn't belongs to any of ladder players" unless player
      raise SecurityError, 'player were banned form ladder' if player.try :banned?
      raise SecurityError, 'invalid password was given' unless player.authenticate pass

      player
    end

    def search params
      chain  = self.ranked

      if params[:players] and not params[:players].empty?
        chain = chain.unscoped.default_order.where :nick_parameterized => params[:players].collect {|p| p.downcase}
      end
      if params[:country] and not params[:country].empty?
        chain = chain.where :country => params[:country]
      end

      time_limit = params[:time_limit].first.to_i rescue 0
      time_limit = default_time_limit if time_limit.zero?
      chain = chain.where 'players.updated_at >= ?', time_limit.days.ago

      chain
    end

    def default_time_limit
      delta = Time.zone.now - Time.zone.local(1970)
      delta.to_i / 1.day
    end
  end
end
