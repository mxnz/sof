class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_comment, only: :destroy
  before_action :current_user_must_own_comment!, only: :destroy

  def create
    @comment = Comment.create(comment_params.merge(user: current_user))
  end

  def destroy
    @comment.destroy!
  end

  private
    def comment_params
      params.require(:comment).permit(:id, :body, :commentable_id, :commentable_type)
    end

    def load_comment
      @comment = Comment.find(params[:id])
    end

    def current_user_must_own_comment!
      forbid_if_current_user_doesnt_own(@comment)
    end
end
