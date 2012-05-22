require 'saulabs/trueskill'

class Rating < Saulabs::TrueSkill::Rating
  attr_accessor :player, :side

  def apply
    @player.mean      = @side.mean      = mean
    @player.deviation = @side.deviation = deviation

    @player.save ; @side.save
  end

  def initialize mean, deviation
    super mean, deviation, 1.0, 25 / 150.0
  end

  def to_f
    mean - 3 * deviation
  end

  def to_s
    to_f.to_s
  end
end
