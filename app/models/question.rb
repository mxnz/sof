class Question < ActiveRecord::Base
  include Attachable
  include Votable

  belongs_to :user, inverse_of: :questions
  has_many :answers, -> { order 'best desc' }, dependent: :destroy, inverse_of: :question
  has_many :comments, dependent: :destroy, as: :commentable
  has_many :email_subs, dependent: :destroy

  validates :title, :body, :user, presence: true
end
