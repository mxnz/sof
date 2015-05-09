class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable, only: :create
  before_action :load_comment, only: :destroy

  authorize_resource

  respond_to :js

  def create
    respond_with(@comment = Comment.create(comment_params.merge(user: current_user, commentable: @commentable)))
  end

  def destroy
    respond_with(@comment.destroy!)
  end

  private
    def load_commentable
      if params[:question_id]
        @commentable = Question.find(params[:question_id])
      elsif params[:answer_id]
        @commentable = Answer.find(params[:answer_id])
      end
    end

    def comment_params
      params.require(:comment).permit(:id, :body)
    end

    def load_comment
      @comment = Comment.find(params[:id])
    end
end
