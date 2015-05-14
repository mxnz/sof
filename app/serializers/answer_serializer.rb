class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :question_id, :user_id, :rating, :best, :created_at, :updated_at

  has_many :comments

  include AttachmentSerializable
end
