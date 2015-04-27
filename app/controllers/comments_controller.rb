class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable, only: :create
  before_action :load_comment, only: :destroy
  before_action :current_user_must_own_comment!, only: :destroy

  def create
    @comment = Comment.create(comment_params.merge(user: current_user, commentable: @commentable))
  end

  def destroy
    @comment.destroy!
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

    def current_user_must_own_comment!
      forbid_if_current_user_doesnt_own(@comment)
    end
end
