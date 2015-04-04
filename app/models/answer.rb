class Answer < ActiveRecord::Base
  belongs_to :user
  belongs_to :question
  has_many :attachments, dependent: :destroy, as: :attachable

  validates :user, :question, :body, presence: true

  accepts_nested_attributes_for :attachments, allow_destroy: true, reject_if: :all_blank

  before_save :ensure_the_best_is_unique, if: ->() { best? && best_changed? }

  private
    def ensure_the_best_is_unique
      Answer.where(question_id: question_id, best: true).update_all(best: false)
    end
end
