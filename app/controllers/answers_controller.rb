class AnswersController < ApplicationController
  before_action :authenticate_user!, except: :index
  before_action :load_answer, only: [:update, :update_best, :destroy]
  before_action :current_user_must_own_answer!, only: [:update, :destroy]
  before_action :current_user_must_own_question!, only: [:update_best]

  def index
    @question = find_question(params[:question_id])
    json_render_many @question.answers
  end

  def create
    @question = find_question(params[:question_id])
    @answer = @question.answers.create(answer_params.merge(user: current_user))
    @answer.errors.blank? ?
      json_render_many(@question.answers) :
      json_render_errors_of(@answer)
  end

  def update
    if @answer.update(answer_params.merge(user: current_user))
      json_render_single @answer
    else
      json_render_errors_of @answer
    end
  end

  def update_best
    if @answer.update(best_param_only)
      @question = find_question(@answer.question_id)
      json_render_many @question.answers
    else
      json_render_errors_of @answer 
    end
  end

  def destroy
    @answer.destroy!
    json_render_single @answer
  end


  private
  
    def answer_params
      params.require(:answer).permit(:body, attachments_attributes: [:id, :file, :_destroy])
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

    def current_user_must_own_answer!
      forbid_if_current_user_doesnt_own(@answer)
    end
    
    def current_user_must_own_question!
      forbid_if_current_user_doesnt_own(@answer.question)
    end
    
    def best_param_only
      params.require(:answer).permit(:best)
    end

    def find_question(question_id)
      Question.includes(answers: [:attachments]).find(question_id)
    end

    def json_render_single(answer)
      render partial: 'answer', formats: [:json], locals: { answer: answer }
    end

    def json_render_many(answers)
      render partial: 'answers', formats: [:json], locals: { answers: answers }
    end
    
    def json_render_errors_of(answer)
      render json:  answer.errors.full_messages, status: :unproccessable_entity
    end
end
