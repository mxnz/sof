class Subscription < ActiveRecord::Base
  belongs_to :user, inverse_of: :subscriptions
  belongs_to :question, inverse_of: :subscriptions

  validates :user, presence: true
  validates :question_id, uniqueness: { scope: :user_id }

  scope :to_questions_digest_not_sent_after, ->(date) { where(question_id: nil).
    where("coalesce(sent_at, '1970-01-01') < :date", date: date)
  }
end
