class EmailSub < ActiveRecord::Base
  belongs_to :user, inverse_of: :email_subs
  belongs_to :question, inverse_of: :email_subs

  validates :user, presence: true
  validates :question_id, uniqueness: { scope: :user_id }
end
