module PlayersHelper
  def avatar_for player, big = false
    image = File.join 'avatars', player.color.to_s, player.avatar_filename
    image_tag image, :alt => '', :class => ('avatar' unless big)
  end

  def rank_for_index int
    page = params[:page].to_i
    page = 1 if page.zero?
    Player.per_page * (page - 1) + (int + 1)
  end

  def flag_for player
    image = File.join 'flags', player.country_filename
    return image_tag image, :alt => ''
  end

  def formatted_rank rank
    return 'Unranked' unless rank
    rank
  end

  def formatted_rating rating
    return '%.3f' % rating.to_f if rating
    '---'
  end

  def options_for_country selected
    options_for_select Country.for_select, selected
  end

  def options_for_time_limit selected
    limit_options  = [['week', 7], ['month', 31], ['three months', 93], ['six months', 186], ['year', 365]]
    options_for_select limit_options, selected
  end

  def player_action_date player
    local_time(player.updated_at).to_s :short
  end

  def player_games_button
    link = games_path 'search[players]' => @player.nick
    bootstrap_link_button 'zoom-out', 'Search For Games', link
  end

  def player_games_played_from_time_limit player
    games = player.games.confirmed

    if params[:search] and params[:search][:time_limit]
      return games.since(params[:search][:time_limit].to_i).count
    end

    games.count
  end

  def player_link player
    avatar = link_to avatar_for(player), player
    nick   = link_to player.nick, player
    avatar.safe_concat('&nbsp;').safe_concat(nick)
  end
end
