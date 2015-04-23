json.(answer, :id, :body, :rating, :best, :user_id, :question_id)
json.destroyed answer.destroyed?

json.attachments answer.attachments do |attachment|
  json.(attachment, :id, :attachable_id, :attachable_type)
  json.file do 
    json.identifier   attachment.file.identifier
    json.url          attachment.file.url
  end
end
