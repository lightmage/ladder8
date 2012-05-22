module BootstrapHelper
  def bootstrap_admin_classes small = true
    classes = %w(btn btn-danger btn-small)
    button_submit_classes classes, small
  end

  def bootstrap_admin_link_button icon_name, text, destination
    bootstrap_link_button icon_name, text, destination, bootstrap_admin_classes
  end

  def bootstrap_close_character
    "&#215;".html_safe
  end

  def bootstrap_dismiss_modal
    link_to bootstrap_close_character, '#', :class => 'close', 'data-dismiss' => 'modal'
  end

  def bootstrap_dropdown_link
    link_to '#', 'class' => 'dropdown-toggle', 'data-toggle' => 'dropdown' do
      raw 'Player ' + content_tag(:b, '', :class => 'caret')
    end
  end

  def bootstrap_game_header text, icon_name
    content_tag :h2, icon(icon_name).safe_concat(" #{text} "), :class => 'game-info'
  end

  def bootstrap_header
    content_tag :header,  :class => 'navbar navbar-fixed-top' do
      content_tag :div,   :class => 'navbar-inner' do
        content_tag(:div, :class => 'container') {yield}
      end
    end
  end

  def bootstrap_ie_html_shim
    '<!--[if lt IE 9]>
       <script src="http://html5shim.googlecode.com/svn/trunk/html5.js" type="text/javascript"></script>
     <![endif]-->'.html_safe
  end

  def bootstrap_large_input
    'input-xxlarge'
  end

  def bootstrap_link_button icon_name, text, destination, classes = bootstrap_submit_classes(true)
    link_to destination, :class => classes do
      raw "#{icon icon_name, true} #{text}"
    end
  end

  def bootstrap_page_header main_text, extra_text = nil
    content_for :header do
      page_header main_text, extra_text
    end
  end

  def bootstrap_page_header_long main_text, extra_text = nil
    content_for :long_header do
      page_header main_text, extra_text
    end
  end

  def bootstrap_reset_classes small = false
    classes = %w(form-reset btn btn-warning)
    button_submit_classes classes, small
  end

  def bootstrap_search_classes
    'search-query input-small'
  end

  def bootstrap_search_form action
    form_tag(action, :authenticity_token => false, :class => 'form-search well', :method => 'get') {yield}
  end

  def bootstrap_short_row
    content_tag :div, :class => 'row' do
      content_tag(:div, :class => 'span8') {yield}
    end
  end

  def bootstrap_submit_classes small = false
    classes = %w(btn btn-info)
    button_submit_classes classes, small
  end

  def bootstrap_submit_tag text
    submit_tag text, :class => bootstrap_submit_classes
  end

  def bootstrap_table condensed = false
    classes = %w(table table-striped)
    classes.push 'table-condensed' if condensed

    content_tag(:table, :class => classes) {yield}
  end

  private

  def button_submit_classes base, small
    base.push 'btn-small' if small
    base.join ' '
  end

  def page_header main_text, extra_text = nil
    content_for :title, "#{main_text} - Ladder8"

    content_tag :h1, :class => 'page-header' do
      extra = content_tag :small, extra_text if extra_text
      "#{main_text} #{extra}".html_safe
    end
  end
end
