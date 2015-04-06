class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @question = find_question(params[:question_id])
    @answer = @question.answers.create(answer_params.merge(user: current_user))
  end

  def update
    @answer = Answer.includes(:question, :attachments).find(params[:id])
    @answer.update(answer_params.merge(user: current_user)) if current_user.owns?(@answer)
  end

  def update_best
    @answer = Answer.includes(:user, :question).find(params[:id])
    if current_user.owns?(@answer.question)
      @question = find_question(@answer.question_id) if @answer.update(best_param_only) 
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    @answer.destroy! if current_user.owns?(@answer)
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
end
