class QuestionBriefSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :user_id, :rating, :created_at, :updated_at
end
