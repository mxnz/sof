require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  let(:question) { create(:question) }
  let(:vote) { build(:vote, votable: question) }

  describe "POST #create" do
    login_user
    subject { post :create, vote: vote.attributes, format: :js }

    it { should render_template :change }

    it "saves a new vote" do
      expect { subject }.to change(question.votes, :count).by(1)
    end

    it "increment question's rating" do
      expect { subject }.to change { question.reload.rating }.by(1)
    end
  end
end
