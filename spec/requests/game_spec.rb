# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Game', type: :request do
  let(:game) { create(:game) }
  let(:creator_p) do
    create(:participant, name: game.creator.username,
                         number: game.creator.number,
                         game_id: game.id)
  end
  let(:participant1) { create(:participant, game_id: game.id) }
  let(:participant2) { create(:participant, game_id: game.id) }
  let(:participant3) { create(:participant, game_id: game.id) }

  describe ':id' do
    it 'returns http success' do
      get "/games/#{game.id}"
      expect(response).to have_http_status(:success)
    end

    it 'destroy?' do
      expect(game.destroy).to be(game)
    end
  end

  describe 'edit' do
    it 'gets success' do
      sign_in game.creator
      get edit_game_path(game)
      expect(response).to have_http_status(:success)
    end

    it 'gets redirect' do
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

  describe 'with winner' do
    it 'destroy?' do
      game.update(winner_id: participant1.id)
      expect(game.destroy).to be(game)
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
