class PlayersController < ApplicationController
  before_filter :authorize,     :only => [:edit, :update]
  before_filter :generate_code, :only => [:new,  :create]

  def index
    criteria   = process_search params[:search]
    @players   = Player.search(criteria).paginate :page => request[:page]
    @newcomers = Player.newcomers

    if criteria.key? :country
      @newcomers = @newcomers.from_country criteria[:country]
    end
  end

  def show
    @player = Player.find params[:id]
    @player.comments.offset(20).destroy_all

    session.delete :messages if players_page?
  end

  def new
    @player = Player.new(:import_rating => true)
    set_players_code
  end

  def edit
    @player = Player.find params[:id]
  end

  def create
    @player = Player.new params[:player]
    set_players_code

    if @player.save
      session.delete :code
      session[:player_id] = @player.id
      redirect_to @player, :notice => 'Player was successfully created.'
    else
      render :action => :new
    end
  end

  def update
    @player = Player.find params[:id]

    if @player.update_attributes params[:player], :as => current_player.role
      redirect_to @player, :notice => 'Player was successfully updated.'
    else
      render :action => :edit
    end
  end

  private

  def authorized?
    current_player.try :can_modify_player?, params[:id].to_i
  end

  def generate_code
    session[:code] ||= SecureRandom.hex 3
  end
  
  def set_players_code
    @player.valid_code = session[:code]
  end
end
