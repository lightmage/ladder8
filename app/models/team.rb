class Team < ActiveRecord::Base
  attr_accessible :name, :won

  belongs_to :game

  has_many :players, :through => :sides
  has_many :sides, :dependent => :destroy

  scope :losers, where(:won => false)
  scope :winner, where(:won => true)

  validates_presence_of :name

  def ts_team
    sides.collect {|s| s.ts_rating}
  end
end
