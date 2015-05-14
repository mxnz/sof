RSpec.shared_examples "an unauthorized api request" do
  describe '<<' do
    before do
      options = { format: :json }
      options.merge!(api_request[2]) if api_request[2]
      send api_request[0], api_request[1], options
    end

    it 'returns unauthorized (401) status if there is no access token' do
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns unauthorized (401) status if there is invalid access token' do
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
