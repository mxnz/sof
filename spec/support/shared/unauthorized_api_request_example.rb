RSpec.shared_examples "an unauthorized api request" do
  describe '<<' do
    let(:options) do
      opts = { format: :json }
      opts.merge!(api_request[2]) if api_request[2]
      opts
    end

    it 'returns unauthorized (401) status if there is no access token' do
      send api_request[0], api_request[1], options
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns unauthorized (401) status if there is invalid access token' do
      send api_request[0], api_request[1], options.merge(access_token: 'abcde')
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
