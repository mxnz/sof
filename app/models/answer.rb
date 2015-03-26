class Answer < ActiveRecord::Base
  belongs_to :user
  belongs_to :question
  validates :user, :question, :body, presence: true

  before_save :ensure_the_best_is_unique, if: :best?

  private
    def ensure_the_best_is_unique
      answers = Answer.where(question_id: self.question_id, best: true)
      answers.each { |a| a.update(best: false) if a.id != self.id }
    end
end
