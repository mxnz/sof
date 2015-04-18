class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_vote, only: :destroy
  before_action :current_user_must_own_vote!, only: :destroy

  def create
    @vote = Vote.new(vote_params.merge(user: current_user))
    @vote.save
    @votable = @vote.votable.reload
    render :change
  end

  def destroy
    @vote.destroy!
    @votable = @vote.votable
    render :change
  end
  
  private
    def vote_params
      params.require(:vote).permit(:id, :up, :votable_id, :votable_type);
    end

    def load_vote
      @vote = Vote.find(params[:id])
    end

    def current_user_must_own_vote!
      forbid_if_current_user_doesnt_own(@vote)
    end
end
