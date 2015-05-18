class Answer < ActiveRecord::Base
  include Attachable
  include Votable

  belongs_to :user, inverse_of: :answers
  belongs_to :question, inverse_of: :answers

  has_many :comments, as: :commentable, dependent: :destroy

  validates :user, :question, :body, presence: true

  before_save :ensure_the_best_is_unique, if: ->() { best? && best_changed? }
  after_create :update_author_rating
  after_destroy :update_author_rating

  private
    def ensure_the_best_is_unique
      Answer.where(question_id: question_id, best: true).update_all(best: false)
    end

    def update_author_rating
      Reputation.update_after_answer(self)
    end
end
