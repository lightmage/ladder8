class ApplicationController < ActionController::Base
  before_filter :comments_warn, :current_player

  protect_from_forgery

  rescue_from ActionController::RoutingError, ActiveRecord::RecordNotFound do
    render 'pages/not_found', :status => :not_found
  end

  def authorize
    unless authorized?
      render 'security/unauthorized', :status => :unauthorized
    end
  end

  def current_player
    unless @current_player
      @current_player = Player.find_by_banned_and_id false, session[:player_id]
      @players_last_action = @current_player.updated_at - 1.second if @current_player
      @current_player.try :touch
    end

    @current_player
  end

  def current_player?
    !!current_player
  end

  def filter_blank parameters
    parameters.reject {|key, val| val.blank?}
  end

  def comments_warn
    if current_player? and current_player.has_comments_since? @players_last_action
      session[:messages] = true
    end

    if session[:messages] and not players_page?
      flash.now[:notice] = 'Yours profile has been commented. Check it out!'
    end
  end

  def players_page?
    params[:controller] == 'players' && params[:action] == 'show' && params[:id] == current_player.to_param
  end

  def process_search options
    return {} unless options
    processed = {}

    filter_blank(options).each do |option, items|
      items = items.split(',').collect {|i| i.strip}
      processed[option.to_sym] = items
    end

    processed
  end

  def reset_current_player
    @current_player = nil
  end
end
