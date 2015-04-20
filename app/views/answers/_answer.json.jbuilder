json.(answer, :id, :body, :rating, :best)
json.belongs_to_cur_user           user_signed_in? && (answer.new_record? || current_user.owns?(answer))
json.question_belongs_to_cur_user  user_signed_in? && current_user.owns?(answer.question)
json.can_be_voted_by_cur_user      user_signed_in? && !current_user.owns?(answer)
json.voted_by_cur_user             user_signed_in? && current_user.voted_on?(answer)
json.vote_of_cur_user              user_signed_in? ? current_user.vote_of(answer) : nil
json.destroyed                     answer.destroyed?

json.attachments answer.attachments do |attachment|
  json.(attachment, :id, :attachable_id, :attachable_type)
  json.file do 
    json.identifier   attachment.file.identifier
    json.url          attachment.file.url
  end
end
