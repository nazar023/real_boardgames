# frozen_string_literal: true

require 'rails_helper'


RSpec.describe 'Users', type: :request do
  let(:user) { create(:user) }

  describe 'GET /id/:id' do
    it 'returns http success' do
      sign_in user
      get "/id/#{user.id}"
      expect(response).to have_http_status(:success)
    end
    it 'returns http success' do
      sign_in user
      get '/users/edit'
      expect(response).to have_http_status(:success)
    end
  end
end
