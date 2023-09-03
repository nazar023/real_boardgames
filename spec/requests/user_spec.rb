# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User', type: :request do
  let(:user) { create(:user) }
  let(:user1) { create(:user) }

  describe 'get' do
    it 'edit when User ?' do
      sign_in user
      get '/users/edit'
      expect(response).to have_http_status(:success)
    end

    it 'edit when not User ?' do
      get '/users/edit'
      expect(response).to have_http_status(:found)
    end
  end

  describe 'gets profile' do
    it 'when User' do
      sign_in user
      get "/id/#{user.id}"
      expect(response).to have_http_status(:success)
    end

    it 'when Guest' do
      get "/id/#{user.id}"
      expect(response).to have_http_status(:success)
    end

    it 'when not User' do
      sign_in user1
      get "/id/#{user.id}"
      expect(response).to have_http_status(:success)
    end
  end
end
