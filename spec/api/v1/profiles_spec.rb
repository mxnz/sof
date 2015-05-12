require 'rails_helper'

RSpec.describe 'Profile API', type: :request do
  describe 'GET /me' do
    context 'unauthorized' do
      it 'returns unauthorized (401) status if there is no access_token' do
        get '/api/v1/profiles/me', format: :json
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns unauhtorized (401) status if there is invalid access_toker' do
        get '/api/v1/profiles/me', access_token: 'abcde', format: :json
      end
    end

    context 'authorized' do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

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
end
