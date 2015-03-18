class AnswersController < ApplicationController
  before_action :authenticate_user!

  def new
    @answer = Answer.new
  end

  def create
    @answer = Answer.new(answer_params)
    @answer.user = current_user
    @answer.question_id = params[:question_id]
    if @answer.save
      redirect_to @answer.question
    else
      render :new
    end
  end

  def edit
    @answer = Answer.find(params[:id])
  end

  def destroy
    @answer = Answer.find(params[:id])
    flash[:success] = 'Your answer is removed' if @answer.user_id == current_user.id && @answer.destroy
    redirect_to question_path(@answer.question_id)
  end


  private
    def answer_params
      params.require(:answer).permit(:body)
    end

end
