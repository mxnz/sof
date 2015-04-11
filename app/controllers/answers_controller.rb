class AnswersController < ApplicationController
  before_action :authenticate_user!, except: :index

  def index
    question = Question.includes(answers: [:attachments]).find(params[:question_id])
    respond_to do |format|
      format.json { render json: hashes_for(question.answers) }
    end
  end

  def new
    question = Question.find(params[:question_id])
    respond_to do |format|
      format.json { render json: hash_for(Answer.new(question: question)) }
    end
  end

  def create
    @question = find_question(params[:question_id])
    @answer = @question.answers.create(answer_params.merge(user: current_user))
    respond_to do |format|
      if @answer.errors.present?
        format.json { render json: @answer.errors.full_messages, status: :unprocessable_entity }
      else
        format.json { render json: hashes_for(@question.answers) }
      end
    end
  end

  def update
    @answer = Answer.includes(:question, :attachments).find(params[:id])
    @answer.update(answer_params.merge(user: current_user)) if current_user.owns?(@answer)
    respond_to do |format|
      if @answer.errors.present?
        format.json { render json: @answer.errors.full_messages, status: :unprocessable_entity }
      else
        format.json { render json: hash_for(@answer) }
      end
    end
  end

  def update_best
    @answer = Answer.includes(:user, :question).find(params[:id])
    respond_to do |format|
      if current_user.owns?(@answer.question)
        if @answer.update(best_param_only)
          @question = find_question(@answer.question_id) if @answer.update(best_param_only)
          format.json { render json: hashes_for(@question.answers) }
        else
          format.json { render json: @answer.errors.full_messages, status: :unprocessable_entity }
        end
      else
        format.json { render json: ["Forbidden action!"], status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    @answer.destroy! if current_user.owns?(@answer)
    respond_to do |format|
      if @answer.destroyed?
        format.json { render json: { id: @answer.id  } }
      else
        format.json { render json:  @answer.errors.full_messages, status: :unproccessable_entity }
      end
    end
  end


  private
  
    def answer_params
      params.require(:answer).permit(:body, attachments_attributes: [:id, :file, :_destroy])
    end
    
    def best_param_only
      params.require(:answer).permit(:best)
    end

    def find_question(question_id)
      Question.includes(answers: [:attachments]).find(question_id)
    end

end
