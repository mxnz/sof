class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @questions = Question.all
  end

  def new
    @question = Question.new(user: current_user)
  end

  def show
    @question = Question.includes(:answers).find(params[:id])
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user
    if @question.save
      flash[:success] = 'Your question is published successfully.'
      redirect_to @question
    else
      render :new
    end
  end
  
  def update
    @question = Question.find(params[:id])
    @question.update(question_params) if @question.user_id == current_user.id
  end

  def destroy
    @question = Question.find(params[:id])
    @question.destroy! if @question.user_id == current_user.id
    redirect_to questions_path
  end


  private
    def question_params
      params.require(:question).permit(:title, :body)
    end
end
