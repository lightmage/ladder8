class Map < ActiveRecord::Base
  attr_accessible :name, :slots

  before_validation :parameterize_name

  has_many :games

  default_scope order('slots, name')

  validates_presence_of :name, :name_parameterized, :slots

  def to_s
    "#{slots}p #{name}"
  end

  private

  def parameterize_name
    self.name_parameterized = Map.parameterized_name name
  end
  
  class << self
    def parameterized_name name
      strings = name.gsub(/[^0-9a-z ]+/i, '').squeeze(' ').strip.split(/\s+/)
      strings.reject! {|s| s.blank? or s =~ /\d+p/}
      strings.join(' ').downcase
    end
  end
end
