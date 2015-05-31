class Answer < ActiveRecord::Base
  include Attachable
  include Votable

  belongs_to :user, inverse_of: :answers
  belongs_to :question, inverse_of: :answers, touch: true

  has_many :comments, as: :commentable, dependent: :destroy

  validates :user, :question, :body, presence: true

  before_save :ensure_the_best_is_unique, if: ->() { best? && best_changed? }
  after_create :update_author_rating, :notify_question_subscribers
  after_destroy :update_author_rating
  after_update :update_best_answer_author_rating, if: ->() { best_changed? }

  def first?
    !question.answers.where("created_at < ?", created_at).any?
  end

  def to_own_question?
    user_id == question.user_id
  end

  private
    def ensure_the_best_is_unique
      Answer.where(question_id: question_id, best: true).update_all(best: false)
    end

    def update_author_rating
      Reputation.update_after_answer(self)
    end

    def update_best_answer_author_rating
      Reputation.update_after_best_answer(self)
    end

    def notify_question_subscribers
      AnswerNotificationsJob.perform_later(id)
    end
end
