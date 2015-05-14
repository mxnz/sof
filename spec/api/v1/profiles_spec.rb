require 'rails_helper'

RSpec.describe 'Profile API', type: :request do
  let(:me) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: me.id) }

  describe 'GET /profiles/me' do
    context 'unauthorized' do
      it_behaves_like 'an unauthorized api request' do
        let(:api_request) { [:get, '/api/v1/profiles/me'] }
      end
    end

    context 'authorized' do
      before { get '/api/v1/profiles/me', access_token: access_token.token, format: :json }

      it 'returns access (200) status' do
        expect(response).to have_http_status(:success)
      end

      it 'should contain my profile' do
        expect(response.body).to be_json_eql(me.to_json)
      end
      
      %w{password encrypted_password}.each do |attr|
        it "should not contain #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end
  end

  describe 'GET /profiles' do
    context 'unauthorized' do
      it_behaves_like 'an unauthorized api request' do
        let(:api_request) { [:get, '/api/v1/profiles'] }
      end
    end

    context 'authorized' do
      let!(:other_users) { create_list(:user, 2) }
      before { get '/api/v1/profiles', access_token: access_token.token, format: :json }

      it 'returns success (200) status' do
        expect(response).to have_http_status(:success)
      end

      it 'returns all profiles except mine' do
        expect(response.body).to be_json_eql(other_users.to_json).at_path('profiles')
      end
    end
  end
end
