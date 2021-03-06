class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_vote, only: :destroy

  authorize_resource

  respond_to :js


  def create
    @vote = Vote.create(vote_params.merge(user: current_user))
    respond_with(@votable = @vote.votable.reload, template: 'votes/change')
  end

  def destroy
    @vote.destroy!
    respond_with(@votable = @vote.votable, template: 'votes/change')
  end
  
  private
    def vote_params
      params.require(:vote).permit(:id, :up, :votable_id, :votable_type);
    end

    def load_vote
      @vote = Vote.find(params[:id])
    end
end
