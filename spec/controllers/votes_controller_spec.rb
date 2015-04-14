require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  let(:question) { create(:question) }
  let(:vote) { build(:vote, votable: question) }
  let!(:pr_vote) { create(:vote, votable: question) }

  describe "POST #create" do
    login_user
    subject { post :create, vote: vote.attributes, format: :js }

    it { should render_template :change }

    it "saves a new vote" do
      expect { subject }.to change(question.votes, :count).by(1)
    end

    it "increments question's rating" do
      expect { subject }.to change { question.reload.rating }.by(1)
    end
  end

  describe "POST #destroy" do

    context 'own vote' do
      before { login pr_vote.user }
      subject { delete :destroy, id: pr_vote.id, format: :js }

      it { should render_template :change }

      it "removes vote" do
        expect { subject }.to change { Vote.find_by(id: pr_vote.id).present? }.from(true).to(false)
      end

      it "decrements question's rating" do
        expect { subject }.to change { question.reload.rating }.by(-1)
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
