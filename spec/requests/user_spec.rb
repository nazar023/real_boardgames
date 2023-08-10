# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:user) { create(:user) }
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:game) { create(:game, creator: user)}

  describe 'destroy' do
    it 'destroy?' do
      create(:friend, user_id: user1.id, whoSent_id: user.id)
      create(:friend, user_id: user.id, whoSent_id: user2.id, request: false)
      create(:participant, game_id: game.id, user_id: user.id)
      expect(user.destroy).to be(user)
    end
  end


  describe 'profile' do
    it 'when loged in' do
      sign_in user
      get "/id/#{user.id}"
      expect(response).to have_http_status(:success)
    end
    it 'when loged out' do
      get "/id/#{user.id}"
      expect(response).to have_http_status(:success)
    end
    it 'edit when loged in' do
      sign_in user
      get '/users/edit'
      expect(response).to have_http_status(:success)
    end
    it 'edit when loged out' do
      get '/users/edit'
      expect(response).to have_http_status(:found)
    end
    it 'does not have avatar' do
      sign_in user
      expect(user.avatar.attached?).to be(false)
    end
  end
end
