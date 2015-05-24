class EmailSubsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_question, only: :create
  before_action :load_email_sub, only: :destroy

  authorize_resource

  respond_to :js

  def create
    respond_with(@email_sub = current_user.email_subs.create(question: @question), template: 'email_subs/change')
  end

  def destroy
    respond_with(@email_sub.destroy!, template: 'email_subs/change')
  end

  private
    def load_question
      @question = Question.find(params[:email_sub][:question_id])
    end

    def load_email_sub
      @email_sub = EmailSub.includes(:question).find(params[:id])
    end
end
