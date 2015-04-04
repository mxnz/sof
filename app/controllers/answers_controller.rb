class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @question = Question.find(params[:question_id])
    @answer = Answer.create(answer_params.merge(user: current_user, question: @question))
    @question = Question.includes(answers: [:attachments]).find(params[:question_id]) if @answer.errors.empty?
  end

  def update
    @answer = Answer.find(params[:id])
    @answer.update(answer_params) if current_user.owns?(@answer)
  end

  def update_best
    @answer = Answer.includes(:question).find(params[:id])
    @answer.update(best_param_only) if current_user.owns?(@answer.question)
    @question = @answer.question
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
end
