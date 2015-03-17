class Answer < ActiveRecord::Base
  belongs_to :user
  belongs_to :question
  validates :user, :question, :body, presence: true
end
