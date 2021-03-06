class AnswersController < ApplicationController
  before_action :authenticate_user!, except: :index
  before_action :load_question, only: [:index, :create]
  before_action :load_answer, only: [:update, :update_best, :destroy]

  after_action :publish_answer, only: [:update, :destroy]
  after_action :publish_answers, only: [:create, :update_best]

  authorize_resource

  responders ErrorsJsonResponder

  respond_to :json

  def index
    respond_with(@question.answers, partial: 'answers', locals: { question: @question })
  end

  def create
    @answer = @question.answers.create(answer_params.merge(user: current_user))
    respond_with(@answer, errors_only: true)
  end

  def update
    @answer.update(answer_params.merge(user: current_user))
    respond_with(@answer, errors_only: true)
  end

  def update_best
    @answer.update(best_param_only)
    @question = find_question(@answer.question_id) if @answer.errors.blank?
    respond_with(@answer, errors_only: true)
  end

  def destroy
    respond_with(@answer.destroy!, errors_only: true)
  end


  private
  
    def answer_params
      params.require(:answer).permit(:body, attachments_attributes: [:id, :file, :_destroy])
    end

    def load_question
      @question = find_question(params[:question_id])
    end

    def load_answer
      case action_name
        when 'update'
          @answer = Answer.includes(:question, :attachments).find(params[:id])
        when 'update_best'
          @answer = Answer.includes(:user, :question).find(params[:id])
        when 'destroy'
          @answer = Answer.find(params[:id])
      end
    end
    
    def best_param_only
      params.require(:answer).permit(:best)
    end

    def find_question(question_id)
      Question.includes(answers: [:attachments]).find(question_id)
    end

    def publish_answer
      return if @answer.errors.present?
      rendered_answer = render_to_string partial: 'answer', formats: [:json], locals: { answer: @answer }
      PrivatePub.publish_to "/questions/#{@answer.question_id}", answer: rendered_answer
    end

    def publish_answers
      return if @answer.errors.present?
      answers = render_to_string partial: 'answers', formats: [:json], locals: { question: @question }
      PrivatePub.publish_to "/questions/#{@question.id}", answers: answers
    end
end
