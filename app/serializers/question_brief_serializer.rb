class QuestionBriefSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :rating, :created_at, :updated_at
end
