class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :update, :destroy]
  before_action :current_user_must_own_question!, only: [:update, :destroy]

  def index
    @questions = Question.all
  end

  def new
    @question = Question.new(user: current_user)
  end

  def show
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user
    if @question.save
      flash[:success] = 'Your question is published successfully.'
      redirect_to @question
      PrivatePub.publish_to '/questions', render_to_string('create', formats: [:js], locals: { question: @question })
    else
      render :new
    end
  end
  
  def update
    @question.update(question_params)
  end

  def destroy
    @question.destroy! 
    respond_to do |format|
      format.html { redirect_to questions_path }
      format.js
    end
  end


  private
    def question_params
      params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
    end

    def load_question
      case action_name
        when 'show'
          @question = Question.includes(:attachments, :comments, answers: [:attachments]).find(params[:id])
        when 'update'
          @question = Question.includes(:user, :attachments).find(params[:id])
        when 'destroy'
          @question = Question.find(params[:id])
      end
    end

    def current_user_must_own_question!
      forbid_if_current_user_doesnt_own(@question)
    end
end
