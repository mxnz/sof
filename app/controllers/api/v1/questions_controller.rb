class Api::V1::QuestionsController < Api::V1::BaseController

  def index
    respond_with Question.all, each_serializer: QuestionBriefSerializer
  end

  def show
    respond_with Question.find(params[:id])
  end

  def create
    respond_with Question.create(question_params.merge(user: current_resource_owner))
  end

  private
    def question_params
      params.require(:question).permit(:title, :body)
    end
end
