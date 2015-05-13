RSpec.shared_examples "a not found api request" do
  describe "<<" do
    before do
      options = { format: :json }
      options.merge!(api_request[2]) if api_request[2].present?
      send api_request[0], api_request[1], options
    end

    it 'returns not found (404) status' do
      expect(response).to have_http_status(:not_found)
    end

    it 'contains error message' do
      expect(response.body).to have_json_path('error_message')
    end
  end
end
