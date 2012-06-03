require 'weskit/wml'

class Replay
  attr_accessor :nodes, :replay
  private_class_method :new

  def chat
    @chat ||= nodes.replay.command.speak.collect do |speak|
      speaker = speak[:id].to_s.strip
      message = speak[:message].to_s.strip.squeeze('"')
      observe = observer? speak[:team_name].to_s.strip

      [speaker, message, observe]
    end
  end

  def era
    @era ||= nodes.replay_start.multiplayer[:mp_era].titleize.strip.sub('Rby', 'RBY')
  end

  def info
    @info ||= {
      :chat    => chat.to_yaml,
      :era     => era,
      :map     => map_name,
      :replay  => replay,
      :rby     => rby?,
      :turns   => turns,
      :title   => title,
      :version => version
    }
  end

  def map_name
    @map_name ||= Map.parameterized_name nodes.replay_start[:name]
  end

  def players
    @players ||= sides.collect {|s| s[:player]}
  end

  def processed_info
    @processed_info ||= process_info
  end

  def rby?
    @rby ||= !!(nodes.replay_start[:id] =~ /^RBY/)
  end

  def rmp?
    @rmp ||= !!(nodes.replay_start[:id] =~ /^RMP/)
  end

  def sides
    @sides ||= playable_sides.collect do |side|
      {
        :color   => Color.find(side[:color]),
        :faction => find_faction(side),
        :leader  => find_leader(side),
        :number  => side[:side].to_i,
        :player  => side[:name],
        :team    => side[:team_name]
      }
    end
  end

  def teams
    @teams ||= sides.collect{|s| s[:team]}.uniq
  end

  def teams_with_processed_sides
    @teams_with_processed_sides = Hash.new

    teams_with_sides.each do |team, sides|
      @teams_with_processed_sides[team] = sides.collect {|s| process! s}
    end

    @teams_with_processed_sides
  end

  def teams_with_sides
    @sides_by_team ||= sides.group_by {|s| s[:team]}
  end

  def title
    @title ||= titleize nodes[:mp_game_title]
  end

  def turns
    @turns ||= nodes[:label].split(' Turn ').last.to_i
  end

  def version
    @version ||= nodes[:version].split('.')[0, 2].join('.')
  end

  private

  def find_faction side
    recruits = side[:previous_recruits].blank? ? side[:recruit] : side[:previous_recruits]
    guess_faction recruits
  end

  def find_leader side
    return side[:type] if side[:type]
    side.unit.detect{|u| u[:canrecruit]}[:type]
  end

  def guess_faction string
    case string
      when /Cavalryman/ then 'Loyalists'
      when /Drake/      then 'Drakes'
      when /Dwarvish/   then 'Knalgan Alliance'
      when /Elvish/     then 'Rebels'
      when /Orcish/     then 'Northerners'
      when /Skeleton/   then 'Undead'
    end
  end

  def observer? name
    'observer' == name
  end

  def playable_sides
    @playable_sides ||= nodes.replay_start.side.reject {|s| false == s[:allow_player]}
  end

  def process_info
    infod       = info.dup
    infod[:map] = Map.find_by_name_parameterized_and_slots! infod[:map], sides.size
    infod
  rescue ActiveRecord::RecordNotFound
    raise ArgumentError
  end

  def process! side
    side = side.dup
    side[:player] = Player.find_by_nick_parameterized! side[:player].downcase
    side.delete :team
    side
  end

  def titleize string
    string.to_s.strip.titleize.gsub(/\s+/, ' ')
  end

  class << self
    def load uri
      replay = new
      replay.replay = uri

      reader = Weskit::WML::Reader.new
      replay.nodes = reader.read_uri uri

      replay
    end
  end
end
