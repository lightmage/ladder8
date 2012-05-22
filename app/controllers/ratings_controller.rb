class RatingsController < ApplicationController
  def index
    player  = Player.find params[:player_id]

    ratings  = [player.initial_rating.to_f]
    @ratings = player.sides.sorted.inject(ratings) do |array, side|
      array << side.rating.to_f ; array
    end
  end
end
