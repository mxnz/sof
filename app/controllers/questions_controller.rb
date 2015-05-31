class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :update, :destroy]

  after_action :publish_question, only: :create

  authorize_resource

  respond_to :html, except: :update
  respond_to :js, only: [:update]


  def index
    respond_with(@questions = Question.all)
  end

  def new
    respond_with(@question = Question.new(user: current_user))
  end

  def show
    respond_with @question
  end

  def create
    respond_with(@question = Question.create(question_params.merge(user: current_user)))
  end
  
  def update
    respond_with(@question.update(question_params))
  end

  def destroy
    @question.destroy!
    respond_to do |format|
      format.html { respond_with(@question) }
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
          @question = Question.includes(:attachments, :comments).find(params[:id])
        when 'update'
          @question = Question.includes(:user, :attachments).find(params[:id])
        when 'destroy'
          @question = Question.find(params[:id])
      end
    end

    def publish_question
      return if @question.errors.present?
      PrivatePub.publish_to '/questions', render_to_string('create', formats: [:js], locals: { question: @question })
    end
end
