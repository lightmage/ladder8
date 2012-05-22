class SidesController < ApplicationController
  def update
    @side = Side.find params[:id]

    if authorized?
      flash[:notice] = 'Side has been successfully confirmed.' if @side.confirm
    end

    redirect_to @side.team.game
  end

  private

  def authorized?
    @side.can_be_modified_by? current_player
  end
end
