module GamesHelper
  def can_confirm? side
    not side.confirmed? and @current_player.try :authorized_to_confirm?, side
  end

  def confirm_button side
    classes = bootstrap_submit_classes(true) + ' reset-bottom '
    button_to 'Confirm', game_side_path(@game, side), :class => classes, :form_class => 'reset-bottom', :method => 'put'
  end

  def display_comments?
    @current_player or not @game.comments.count.zero?
  end

  def game_feed_options
    {
      :controller => :games,
      :action     => :index,
      :format     => :atom,
      'search[players]'  => (search_param :players),
      'search[factions]' => (search_param :factions),
      'search[leaders]'  => (search_param :leaders),
      'search[maps]'     => (search_param :maps)
    }
  end

  def game_reported_date time, format = :rfc822
    local_time(time).to_date.to_s format
  end

  def game_table_name game
    "#{link_to game.map.name, game} Turn #{link_to game.turns, game}".html_safe
  end

  def games_feed
    content_for :feed do
      auto_discovery_link_tag :atom, game_feed_options
    end
  end

  def has_only_private_errors?
    @game.public_errors.empty? and not @game.errors.empty?
  end

  def link_to_archive
    link_to 'archive', "http://replays.wesnoth.org/#{Ladder8::Application.config.wesnoth_version}/#{Time.now.strftime '%Y%m%d'}/"
  end

  def observer_message entry
    speaker = content_tag :td, entry[:speaker], :class => 'observer'
    message = content_tag :td, entry[:message], :class => ('obs-chat' if entry[:obs])

    speaker.safe_concat message
  end

  def played?
    @current_player and @game.player_ids.include? @current_player.id
  end

  def player_message entry
    speaker = content_tag :td, player_link(entry[:speaker]), :class => 'player'
    message = content_tag :td, entry[:message]

    speaker.safe_concat message
  end

  def server_message entry
    content_tag :td, entry[:message], :class => 'server', :colspan => 2
  end

  def side_link side
    rating = formatted_rating side.rating
    [player_link(side.player), content_tag(:span, rating), side.faction].join('&nbsp;').html_safe
  end

  def toggle_chat_header
    bootstrap_game_header link_to('Chat', '#', :id => 'chat-toggle'), 'th-list'
  end

  def toggle_comments_header comments
    text = link_to 'Comments', '#', :id => 'comments-toggle'
    text << " " << comments.to_s unless comments.zero?
    bootstrap_game_header text, 'comment'
  end

  def waiting_for_confirmation?
    (admin? or played?) and not @game.confirmed_cache?
  end
end
