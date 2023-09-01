# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Game', type: :request do
  let(:game) { create(:game) }
  let(:participant1) { create(:participant, game_id: game.id) }
  let(:participant2) { create(:participant, game_id: game.id) }
  let(:participant3) { create(:participant, game_id: game.id) }

  describe 'games/:id' do
    it 'returns http success' do
      get "/games/#{game.id}"
      expect(response).to have_http_status(:success)
    end

    it 'destroy?' do
      expect(game.destroy).to be(game)
    end

    it 'has creator' do
      expect(game.creator).to be_truthy
    end

    it 'has creator participant' do
      expect(game.participants.first).to be_truthy
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

      it 'update?' do
        sign_in game.creator
        game.update(name: 'Fief', desc: 'lalalal', members: game.members)
        expect(game.desc).to eq('lalalal')
        expect(game.name).to eq('Fief')
      end

      it 'update? not valid' do
        sign_in game.creator
        game.update(name: '')
        expect(game.valid?).to be_falsey
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
