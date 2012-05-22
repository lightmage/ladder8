module CommentsHelper
  def comment_destroy_link object, comment
    options = {
      :class   => :close,
      :confirm => 'Are you sure?',
      :method  => :delete
    }
    link_to bootstrap_close_character, [object, comment], options
  end

  def comments_div hide, &block
    content_tag :div, :id => 'comments', :style => ('display: none' if hide) do
      block.call
    end
  end

  def comments_partial object, hide = false, only_recent = false
    comments = object.comments
    comments = comments.recent if only_recent

    render :partial => 'comments/list', :locals => {:object => object, :comments => comments, :hide => hide}
  end

  def conditional_comment_destroy_link object, comment
    if comment.can_be_modified_by? @current_player
      comment_destroy_link object, comment
    end
  end
end
