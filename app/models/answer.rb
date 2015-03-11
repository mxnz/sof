class Answer < ActiveRecord::Base
  belongs_to :question
  validates :question, :body, presence: true
end
