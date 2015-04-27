class Question < ActiveRecord::Base
  include Attachable
  include Votable

  belongs_to :user, inverse_of: :questions
  has_many :answers, -> { order 'best desc' }, dependent: :destroy, inverse_of: :question
  has_many :comments, dependent: :destroy, as: :commentable

  validates :title, :body, :user, presence: true
end
