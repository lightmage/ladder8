class News < ActiveRecord::Base
  attr_accessible :title, :body

  belongs_to :player

  default_scope includes(:comments).order('created_at DESC')

  has_many :comments, :as => :commentable, :dependent => :destroy

  validates_presence_of :title, :body

  def to_param
    "#{id} #{title}".parameterize
  end
end
