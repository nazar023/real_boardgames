# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Games', type: :request do
  let(:game) { create(:game) }

  describe 'GET /games/:id' do

    context 'when 1 participants' do
      it 'returns http success' do
        get "/games/#{game.id}"
        expect(response).to have_http_status(:success)
      end

      it 'has creator participant' do
        creator = game.creator
        create(:participant, name: creator.username,
                             number: creator.number,
                             game_id: game.id)
        expect(game.participants.first.number).to eq(game.creator.number)
      end

    end
  end

  describe '/games/:id/edit' do
    context 'can edit' do

      it 'gets success' do
        sign_in game.creator
        get edit_game_path(game)
        expect(response).to have_http_status(:success)
      end

      it 'updates info' do
        sign_in game.creator
        game.update(name: 'Fief', desc: 'lalalal', members: game.members)
        expect(game.desc).to eq('lalalal')
        expect(game.name).to eq('Fief')
      end
  end
end


  describe 'with winner' do
    it 'can destroy' do
      creator = game.creator
      create(:participant, game_id: game.id)
      winner = create(:participant, game_id: game.id, name: creator.username, number: creator.number, user_id: creator.id)
      game.update(winner_id: winner.id)
      game.winner_id = nil
      game.save
      expect(game.destroy).to be(game)
    end
  end

  # TODO: Mission: create tests for all actions

end

# Homework -> Easy rails blog (video)
# Homework -> Draw Database structure for project
# Homework -> betterspecs.org (Всі дії (show update ...))
