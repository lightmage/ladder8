class GamesController < ApplicationController
  before_filter :authorize, :only => [:create]
  before_filter :clean_unconfirmed, :only => [:index, :show]

  def index
    criteria = process_search params[:search]
    games    = Game.search criteria

    respond_to do |format|
      format.html {@games = games.paginate :page => request[:page]}
      format.atom {@games = games.limit Game.per_page}
    end
  end

  def show
    @game = Game.find params[:id]
  end

  def create
    @game = Game.report current_player, params[:replay]

    unless @game.new_record?
      redirect_to @game, :nootice => 'Game was successfully reported.'
    else
      render :action => :new
    end
  end

  private

  def authorized?
    current_player?
  end

  def clean_unconfirmed
    Game.old.unconfirmed.destroy_all
  end
end
