require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  let(:question) { create(:question) }
  let(:vote) { build(:vote, votable: question) }
  let!(:pr_vote) { create(:vote, votable: question) }

  describe "POST #create" do
    login_user
    let(:create_vote) { post :create, vote: vote.attributes, format: :js }

    it 'should render :change' do
      create_vote
      expect(response).to render_template :change
    end

    it "saves a new vote" do
      expect { create_vote }.to change(question.votes, :count).by(1)
    end

    it "increments question's rating" do
      expect { create_vote }.to change { question.reload.rating }.by(1)
    end
  end

  describe "POST #destroy" do

    context 'own vote' do
      before { login pr_vote.user }
      let(:delete_own_vote) { delete :destroy, id: pr_vote.id, format: :js }

      it 'should render :change' do
        delete_own_vote
        expect(response).to render_template :change
      end

      it "removes vote" do
        delete_own_vote
        expect(Vote.find_by(id: pr_vote.id)).to be_nil
      end

      it "decrements question's rating" do
        expect { delete_own_vote }.to change { question.reload.rating }.by(-1)
      end
    end

    context "another user's vote" do
      login_user

      it "doesn't remove vote " do
        expect { delete :destroy, id: pr_vote.id, format: :js }.to_not change(Vote, :count)
      end
    end

  end
end
