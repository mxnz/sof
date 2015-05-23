class EmailSubsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: :create

  authorize_resource

  respond_to :js

  def create
    respond_with(@email_sub = EmailSub.create(user: current_user, question: @question))
  end

  private
    def load_question
      @question = Question.find(params[:email_sub][:question_id])
    end
end
