require 'rails_helper'

RSpec.describe ApiToken, type: :request do
  let(:api_token) { create(:api_token) }

  describe '/api/v1/games' do
    it 'authorize with valid token' do
      get '/api/v1/games', headers: { HTTP_AUTHORIZATION: "Token token=#{api_token.token}" }
      expect(response).to have_http_status(:ok)
    end

    it "can't authorize without token" do
      get '/api/v1/games'
      expect(response).to have_http_status(:unauthorized)
    end

    it "can't authorize with unvalid token" do
      get '/api/v1/games', headers: { HTTP_AUTHORIZATION: 'Token token=dsadsa221312321asas' }
      expect(response).to have_http_status(:unauthorized)
    end

    it "can't authorize with disabled token" do
      api_token.disabled!
      get '/api/v1/games', headers: { HTTP_AUTHORIZATION: "Token token=#{api_token.token}" }
      expect(response).to have_http_status(:unauthorized)
    end

    describe '/api/v1/id/:id' do
      it 'authorize with valid token' do
        require 'json'
        get "/api/v1/id/#{api_token.user.id}", headers: { HTTP_AUTHORIZATION: "Token token=#{api_token.token}" }
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
