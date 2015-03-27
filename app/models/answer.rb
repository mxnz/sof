class Answer < ActiveRecord::Base
  belongs_to :user
  belongs_to :question
  validates :user, :question, :body, presence: true

  before_save :ensure_the_best_is_unique, if: :best?

  private
    def ensure_the_best_is_unique
      Answer.where(question_id: question_id, best: true).update_all(best: false)
    end
end
