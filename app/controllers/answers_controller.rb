class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_answer, only: [:edit, :update, :destroy]

  def create
    @answer = Answer.new(answer_params)
    @answer.user = current_user
    @answer.question_id = params[:question_id]
    @answer.save
  end

  def edit
  end

  def update
    @answer.update(answer_params) if @answer.user_id == current_user.id 
  end

  def destroy
    @answer.destroy! if @answer.user_id == current_user.id
  end


  private
    def answer_params
      params.require(:answer).permit(:body)
    end

    def load_answer
      @answer = Answer.find(params[:id])
    end

end
