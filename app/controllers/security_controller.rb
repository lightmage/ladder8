class SecurityController < ApplicationController
  def code
    unless current_player
      require 'bots/code_worker'

      if params[:player] and session[:code]
        worker = CodeWorker.new params[:player], session[:code]
        result, @message = *worker.send_code
      end
    end
  end

  def login
    return redirect_to_root if current_player

    if request.post?
      begin
        player = Player.login! params[:nick], params[:password]
      rescue SecurityError => e
        @error = e.message
      else
        session[:player_id] = player.id
        redirect_to (request[:previous] or player)
      end
    end
  end

  def logout
    return redirect_to_root unless current_player

    reset_session
    reset_current_player

    redirect_to (request.referer or root_path)
  end

  private

  def redirect_to_root
    redirect_to root_path
  end
end
