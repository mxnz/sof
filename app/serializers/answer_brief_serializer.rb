class AnswerBriefSerializer < ActiveModel::Serializer
  attributes :id, :body, :question_id, :user_id, :rating, :best, :created_at, :updated_at
end
