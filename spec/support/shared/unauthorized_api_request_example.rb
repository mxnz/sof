RSpec.shared_examples "an unauthorized api request" do
  it 'returns unauthorized (401) status if there is no access token' do
    send api_request[0], api_request[1], format: :json
    expect(response).to have_http_status(:unauthorized)
  end

  it 'returns unauthorized (401) status if there is invalid access token' do
    send api_request[0], api_request[1], access_token: 'abcde', format: :json
    expect(response).to have_http_status(:unauthorized)
  end
end
