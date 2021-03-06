require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:identities).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:delete_all) }

  describe '.create' do
    it 'subscribes given user to all questions digest' do
      u = create(:user)
      expect(u.subscriptions.count).to eq 1
      expect(u.subscriptions.last.question).to be_nil
    end
  end

  describe '.from_omniauth' do
    context "when user is unregistered" do
      let(:user) { build(:user) }
      let(:auth) do
        OmniAuth::AuthHash.new({
          provider: 'provider',
          uid: '12345',
          info: {
            email: user.email
          }
        })
      end
      let(:create_from_omniauth) { User.from_omniauth(auth) }
      
      it 'creates user' do
        create_from_omniauth
        expect(User.find_by(email: user.email)).to_not be_nil
      end

      it "increments user's count" do
        expect { create_from_omniauth }.to change(User, :count).by(1)
      end

      it 'creates identity for created user' do
        create_from_omniauth
        expect(Identity.find_by(uid: auth.uid, provider: auth.provider).user.email).to eq user.email
      end
    end

    context 'when user is registered' do
      let!(:user) { create(:user) }
      let(:auth) do
        OmniAuth::AuthHash.new({
          provider: 'provider',
          uid: '12345',
          info: {
            email: user.email
          }
        })
      end
      let(:find_from_omniauth) { User.from_omniauth(auth) }
      
      it 'finds user' do
        expect(find_from_omniauth).to eq user
      end

      it "doesn't increment user's count" do
        expect { find_from_omniauth }.to_not change(User, :count)
      end

      context "when identity doesn't exist" do
        it 'creates new identity for given user' do
          expect { find_from_omniauth }.to change(user.identities, :count).by(1)
        end
      end

      context "when identity exists" do
        before { create(:identity, user: user, uid: auth.uid, provider: auth.provider) }
        it "doesn't create new identity" do
          expect { find_from_omniauth }.to_not change(user.identities, :count)
        end
      end
    end
  end
end
