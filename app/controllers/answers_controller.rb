class AnswersController < ApplicationController
  before_action :authenticate_user!

  def new
    @answer = Answer.new(question_id: params[:question_id])
  end

  def create
    @answer = Answer.new(answer_params)
    @answer.question_id = params[:question_id]
    if @answer.save
      redirect_to @answer.question
    else
      render :new
    end
  end

  private
    def answer_params
      params.require(:answer).permit(:body)
    end

end
