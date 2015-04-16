class AnswersController < ApplicationController
  before_action :authenticate_user!, except: :index

  def index
    question = Question.includes(answers: [:attachments]).find(params[:question_id])
    render json: hashes_for(question.answers)
  end

  def create
    @question = find_question(params[:question_id])
    @answer = @question.answers.create(answer_params.merge(user: current_user))
    if @answer.errors.blank?
      render json: hashes_for(@question.answers) 
    else
      render json: @answer.errors.full_messages, status: :unprocessable_entity 
    end
  end

  def update
    @answer = Answer.includes(:question, :attachments).find(params[:id])
    forbid_if_current_user_doesnt_own(@answer); return if performed?
    @answer.update(answer_params.merge(user: current_user))
    if @answer.errors.blank?
      render json: hash_for(@answer)
    else
      render json: @answer.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update_best
    @answer = Answer.includes(:user, :question).find(params[:id])
    forbid_if_current_user_doesnt_own(@answer.question); return if performed?
    if @answer.update(best_param_only)
      @question = find_question(@answer.question_id) if @answer.update(best_param_only)
      render json: hashes_for(@question.answers)
    else
      render json: @answer.errors.full_messages, status: :unprocessable_entity
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    forbid_if_current_user_doesnt_own(@answer); return if performed?
    @answer.destroy!
    if @answer.destroyed?
      render json: { id: @answer.id  }
    else
      render json:  @answer.errors.full_messages, status: :unproccessable_entity
    end
  end


  private
  
    def answer_params
      params.require(:answer).permit(:body, attachments_attributes: [:id, :file, :_destroy])
    end
    
    def best_param_only
      params.require(:answer).permit(:best)
    end

    def find_question(question_id)
      Question.includes(answers: [:attachments]).find(question_id)
    end
    
    def hash_for(answer)
      json_answer = answer.as_json(include: :attachments).merge(
        belongs_to_cur_user: user_signed_in? && (answer.new_record? || current_user.owns?(answer)),
        question_belongs_to_cur_user: user_signed_in? && current_user.owns?(answer.question),
        voted_by_cur_user: user_signed_in? && current_user.voted_on?(answer),
        vote_of_cur_user: user_signed_in? ? current_user.vote_of(answer) : nil
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
