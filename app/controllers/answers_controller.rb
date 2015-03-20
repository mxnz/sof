class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @answer = Answer.new(answer_params)
    @answer.user = current_user
    @answer.question_id = params[:question_id]
    render :new unless @answer.save
  end

  def edit
    @answer = Answer.find(params[:id])
  end

  def destroy
    @answer = Answer.find(params[:id])
    if @answer.user_id == current_user.id
      flash[:success] = 'Your answer is removed' if @answer.destroy!
    end
    redirect_to question_path(@answer.question_id)
  end


  private
    def answer_params
      params.require(:answer).permit(:body)
    end

end
