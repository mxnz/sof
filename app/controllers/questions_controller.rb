class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @questions = Question.all
  end

  def new
    @question = Question.new
  end

  def show
    @question = Question.includes(:answers).find(params[:id])
  end

  def create
    @question = Question.new(question_params)
    if @question.save
      flash[:success] = 'Your question is published successfully.'
      redirect_to @question
    else
      render :new
    end
  end


  private
    def question_params
      params.require(:question).permit(:title, :body)
    end
end
