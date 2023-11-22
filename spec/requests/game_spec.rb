# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Game', type: :request do
  let(:game) { create(:game) }
  let(:participant1) { create(:participant, game_id: game.id) }
  let(:participant2) { create(:participant, game_id: game.id) }
  let(:participant3) { create(:participant, game_id: game.id) }

  describe 'games/:id' do
    it 'returns http success when guest' do
      get "/games/#{game.id}"
      expect(response).to have_http_status(:success)
    end

    it 'returns http success when signed in' do
      sign_in game.creator
      get "/games/#{game.id}"
      expect(response).to have_http_status(:success)
    end
  end

  describe 'edit' do
    context 'add another user' do
      let(:user) { create(:user) }
      it 'gets success when creator' do
        sign_in game.creator
        get edit_game_path(game)
        expect(response).to have_http_status(:success)
      end

      it 'gets redirect when guest' do
        get edit_game_path(game)
        expect(response).to have_http_status(:found)
      end

      it 'gets redirect when not creator' do
        sign_in user
        get edit_game_path(game)
        expect(response).to have_http_status(:found)
      end
    end
  end

  describe 'with winner' do
    it 'destroy?' do
      game.update(winner_id: participant1.id)
      expect(game.destroy).to be_truthy
    end

    it 'not update' do
      sign_in game.creator
      get edit_game_path(game)
      expect(response).to have_http_status(:success)

      game.update(winner_id: participant2.id)
      get edit_game_path(game)
      expect(response).to have_http_status(:found)
    end
  end
end

# Homework -> Easy rails blog (video)
# Homework -> Draw Database structure for project
# Homework -> betterspecs.org (Всі дії (show update ...))
