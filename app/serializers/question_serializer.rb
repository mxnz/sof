class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :rating, :created_at, :updated_at

  has_many :comments, :attachments
  
  def attachments
    object.attachments.map { |a| a.file.url }
  end
end
