module PagesHelper
  def link_to_gitorious
    link = 'https://gitorious.org/wesnoth-ladder/'
    link_to link, link
  end

  def link_to_microsoft_ts_page
    link = 'http://research.microsoft.com/en-us/projects/trueskill/'
    link_to link, link
  end

  def link_to_moserware_ts_page
    link = 'http://www.moserware.com/2010/03/computing-your-skill.html'
    link_to link, link
  end

  def non_breaking items
    items = items.collect {|item| item.to_s.gsub ' ', '&nbsp;'}
    raw items.join(', ') + '.'
  end
end
