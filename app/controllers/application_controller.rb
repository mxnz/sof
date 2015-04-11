class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def hash_for(answer)
    json_answer = answer.as_json(include: :attachments).merge(
      belongs_to_cur_user: user_signed_in? && (answer.new_record? || current_user.owns?(answer)),
      question_belongs_to_cur_user: user_signed_in? && current_user.owns?(answer.question)
    )
    json_answer["attachments"].each do |jat|
      at = answer.attachments.find { |at| at.id == jat["id"] }
      jat["file"]["identifier"] = at.file.identifier
    end
    json_answer
  end

  def hashes_for(answers)
    answers.map { |a| hash_for a }
  end
end
