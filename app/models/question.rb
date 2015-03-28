class Question < ActiveRecord::Base
  belongs_to :user
  has_many :answers, -> { order 'best desc' }, dependent: :destroy

  validates :title, :body, :user, presence: true
end
