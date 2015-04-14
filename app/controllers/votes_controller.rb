class VotesController < ApplicationController
  before_action :authenticate_user!

  def create
    @vote = Vote.new(vote_params.merge(user: current_user))
    @vote.save
    @votable = @vote.votable.reload
    render :change
  end

  def destroy
    @vote = Vote.find(params[:id])
    @vote.destroy! if current_user.owns?(@vote)
    @votable = @vote.votable
    render :change
  end
  
  private
    def vote_params
      params.require(:vote).permit(:id, :up, :votable_id, :votable_type);
    end

end
