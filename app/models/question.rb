class Question < ActiveRecord::Base
  belongs_to :user, inverse_of: :questions
  has_many :answers, -> { order 'best desc' }, dependent: :destroy, inverse_of: :question
  has_many :attachments, dependent: :destroy, as: :attachable

  validates :title, :body, :user, presence: true

  accepts_nested_attributes_for :attachments, allow_destroy: true, reject_if: :all_blank
end
