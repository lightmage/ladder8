module NewsHelper
  def create_news_button
    bootstrap_admin_link_button 'pencil', 'Create News', new_news_path
  end

  def destory_news_button news
    options = {
      :class   => bootstrap_admin_classes,
      :confirm => 'Are you sure?',
      :method  => :delete
    }
    text = icon('trash', true) + ' Destroy News'
    link_to text, news, options
  end

  def edit_news_button news
    bootstrap_admin_link_button 'pencil', 'Edit News', edit_news_path(news)
  end
end
