class Comment < ActiveRecord::Base
  belongs_to :user, inverse_of: :comments
  belongs_to :commentable, polymorphic: true, touch: true

  validates :user, presence: true
  validates :body, presence: true
  validates :commentable, presence: true
  validates :commentable_type, inclusion: ['Question', 'Answer']

  def question_id
    if commentable_type == 'Question'
      commentable_id
    elsif commentable_type == 'Answer'
      commentable.question_id
    end
  end
end
