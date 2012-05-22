class Comment < ActiveRecord::Base
  attr_accessible :body

  before_save :strip_whitespaces

  belongs_to :commentable, :polymorphic => true
  belongs_to :player

  scope :recent, limit(6)

  validates_presence_of :body

  def can_be_modified_by? player
    author_can_delete = recently_created? and written_by? player
    player.try :admin? or author_can_delete
  end

  def recently_created?
    created_at > 3.minutes.ago
  end

  def strip_whitespaces
    self.body.strip!
  end

  def written_by? author
    author == player
  end
end
