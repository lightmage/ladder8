class Side < ActiveRecord::Base
  attr_accessible :color, :faction, :leader, :number, :player, :team

  belongs_to :player
  belongs_to :team

  default_scope order(:number)
  scope :confirmed, where('sides.confirmed = ?', true)
  scope :sorted, reorder('id')

  validates_presence_of :color, :faction, :leader, :number

  def can_be_modified_by? user
    user.try :admin? or user == player
  end

  def confirm
    Side.transaction do
      status = update_attribute :confirmed, true
      game   = team.game

      if game.sides_confirmed?
        game.update_attribute :confirmed_cache, true
        game.update_ratings
      end
      
      status
    end
  end

  def rating
    return mean - 3 * deviation if mean and deviation
  end

  def to_s
    "#{player}, #{faction}, #{leader}"
  end

  def ts_rating
    rating = player.ts_rating
    rating.side = self
    rating
  end
end
