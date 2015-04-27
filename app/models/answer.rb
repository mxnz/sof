class Answer < ActiveRecord::Base
  include Attachable
  include Votable

  belongs_to :user, inverse_of: :answers
  belongs_to :question, inverse_of: :answers

  has_many :comments, as: :commentable, dependent: :destroy

  validates :user, :question, :body, presence: true

  before_save :ensure_the_best_is_unique, if: ->() { best? && best_changed? }

  private
    def ensure_the_best_is_unique
      Answer.where(question_id: question_id, best: true).update_all(best: false)
    end
end
