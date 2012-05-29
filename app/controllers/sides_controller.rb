class SidesController < ApplicationController
  def update
    @side = Side.find params[:id]

    if authorized?
      unless Game.has_confirmed? @side.team.game.replay
        flash[:notice] = 'Side has been successfully confirmed.'
        @side.confirm
      else
        flash[:notice] = 'This game is already reported and it was confirmed by all players.'
      end
    end

    redirect_to @side.team.game
  end

  private

  def authorized?
    @side.can_be_modified_by? current_player
  end
end
