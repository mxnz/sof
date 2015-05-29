json.cache! answer do
  json.(answer, :id, :body, :rating, :best, :user_id, :question_id)
  json.destroyed answer.destroyed?

  json.attachments answer.attachments do |attachment|
    json.(attachment, :id, :attachable_id, :attachable_type)
    json.file do 
      json.identifier   attachment.file.identifier
      json.url          attachment.file.url
    end
  end

  json.comments answer.comments do |comment|
    json.(comment, :id, :user_id, :body, :commentable_id, :commentable_type)
  end
end
