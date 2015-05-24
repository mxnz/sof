class Question < ActiveRecord::Base
  include Attachable
  include Votable

  belongs_to :user, inverse_of: :questions
  has_many :answers, -> { order 'best desc' }, dependent: :destroy, inverse_of: :question
  has_many :comments, dependent: :destroy, as: :commentable
  has_many :subscriptions, dependent: :delete_all, inverse_of: :question

  validates :title, :body, :user, presence: true

  after_create :subscribe_author_to_question

  private
    def subscribe_author_to_question
      Subscription.create(user: user, question: self)
    end
end
