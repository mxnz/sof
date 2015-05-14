class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :user_id, :rating, :created_at, :updated_at

  has_many :comments

  include AttachmentSerializable
end
