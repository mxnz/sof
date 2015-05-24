require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  context 'for guest' do
    let(:user) { nil }

    it_behaves_like 'a reader'
  end

  context 'for user' do
    let(:user) { create(:user) }

    let(:question) { create(:question, user: user) }
    let(:other_question) { create(:question) }

    let(:answer) { create(:answer, user: user) }
    let(:other_answer) { create(:answer) }
    let(:answer_to_own_question) { create(:answer, question: question) }
    let(:answer_to_other_question) { create(:answer) }

    let(:comment) { create(:comment, commentable: question, user: user) }
    let(:other_comment) { create(:comment, commentable: question) }

    let(:vote_for_own_votable) { build(:vote, votable: question, user: user) }
    let(:vote_for_other_votable) { build(:vote, votable: other_question, user: user) }
    let(:own_vote) { create(:vote, votable: other_question, user: user) }
    let(:other_vote) { create(:vote, votable: other_question) }

    let(:subscription_to_unsubscribed_question) { build(:subscription, user: user, question: create(:question)) }
    let(:subscription_to_subscribed_question) { build(:subscription, user: user, question: create(:subscription, user: user).question) }

    let(:own_subscription_to_question) { create(:subscription, user: user) }
    let(:other_subscription_to_question) { create(:subscription) }


    it_behaves_like 'a reader'

    it { should be_able_to :manage, question }
    it { should_not be_able_to :manage, other_question }

    it { should be_able_to :manage, answer }
    it { should_not be_able_to :manage, other_answer }

    it { should be_able_to :manage, comment }
    it { should_not be_able_to :manage, other_comment }

    it { should be_able_to :update_best, answer_to_own_question }
    it { should_not be_able_to :update_best, answer_to_other_question }

    it { should be_able_to :create, vote_for_other_votable }
    it { should_not be_able_to :create, vote_for_own_votable }

    it { should be_able_to :destroy, own_vote }
    it { should_not be_able_to :destroy, other_vote }

    it { should be_able_to :create, subscription_to_unsubscribed_question }
    it { should_not be_able_to :create, subscription_to_subscribed_question }

    it { should be_able_to :destroy, own_subscription_to_question }
    it { should_not be_able_to :destroy, other_subscription_to_question }
  end
end
