class CommentsController < ApplicationController
  before_filter :authorize

  def create
    commentable    = find_commentable
    comment        = commentable.comments.build params
    comment.player = current_player

    if comment.save
      flash[:notice] = 'Comment was succesfully published.'
    else
      flash[:errors] = 'Comment was rejected.'
    end

    redirect_to commentable
  end

  def destroy
    commentable = find_commentable
    comment     = Comment.find params[:id]

    comment.destroy
    redirect_to commentable, :notice => 'Comment was succesfully deleted.'
  end

  private

  def authorized?
    if params.key? :id
      authorized_to_memeber?
    else
      authorized_to_collection?
    end
  end

  def authorized_to_collection?
    current_player?
  end

  def authorized_to_memeber?
    comment = Comment.find params[:id]
    comment.can_be_modified_by? current_player
  end

  def find_commentable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find value
      end
    end

    nil
  end
end
