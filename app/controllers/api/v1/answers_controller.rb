class Api::V1::AnswersController < Api::V1::BaseController

  def index
    @answers = Question.includes(:answers).find(params[:question_id]).answers
    respond_with @answers, each_serializer: AnswerBriefSerializer
  end

  def show
    respond_with Answer.find(params[:id])
  end

  def create
    @question = Question.find(params[:question_id])
    respond_with Answer.create(answer_params.merge(question: @question, user: current_resource_owner))
  end

  private
    def answer_params
      params.require(:answer).permit(:body)
    end
end
