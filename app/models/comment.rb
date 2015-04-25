class Comment < ActiveRecord::Base
  belongs_to :user, inverse_of: :comments
  belongs_to :commentable, polymorphic: true

  validates :user, presence: true
  validates :body, presence: true
  validates :commentable, presence: true
  validates :commentable_type, inclusion: ['Question', 'Answer']
end
