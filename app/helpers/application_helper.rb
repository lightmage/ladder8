module ApplicationHelper
  def admin?
    !!@current_player.try(:admin?)
  end

  def background_image image = nil
    image ||= Background.random

    image = "portraits/#{image}"
    style = "section.container {background: url(#{asset_path image}) bottom right no-repeat}"

    content_for :background do
      content_tag :style, style, :type => 'text/css'
    end
  end

  def conditional_notice_div
    if flash[:notice]
      content_tag :div, flash[:notice], :class => 'alert alert-info'
    end
  end

  def current_player?
    !!@current_player
  end

  def fork_link
    link_to image_tag('https://s3.amazonaws.com/github/ribbons/forkme_right_darkblue_121621.png', :alt => 'Fork me on Github', :style => 'position: absolute; top: 40px; right: 0; border: 0;'), 'https://github.com/f6p/ladder8'
  end

  def icon name, white = false
    icon_name = "icon #{name}".parameterize
    icon_name << ' icon-white ' if white

    content_tag :i, '', :class => icon_name
  end

  def link_to_textile
    link_to 'Textile', 'http://en.wikipedia.org/wiki/Textile_%28markup_language%29'
  end

  def local_time time
    return time.to_time.in_time_zone @current_player.timezone if @current_player
    time
  end

  def none
    'display: none'
  end

  def restricted_block
    content_tag :div, 'More information is avaiable only to registered users.', :class => 'alert alert-info'
  end

  def search_param name
    if request[:search].present?
      request[:search][name.to_sym].to_s 
    end
  end

  def seasonal_background
    month = Time.now.month

    color, image = case month
      when 1..4
        ['#808c9a', 'winter']
      when 5..8
        ['#a2e9ff', 'summer']
      else
        ['#6f7983', 'fall']
    end

    image = "backgrounds/#{image}.jpg"
    style = "body {background: #{color} url(#{asset_path image}) bottom center no-repeat fixed !important}"

    content_tag :style, style, :type => 'text/css'
  end

  def textile text
    text = lame text
    text = RedCloth.new text

    text.to_html.html_safe
  end

  private

  def lame text
    lame = text
    crap = {'&' => '&amp;', '>' => '&gt;', '<' => '&lt;'}
    crap.each {|k, v| lame.gsub k, v}
    lame
  end
end
