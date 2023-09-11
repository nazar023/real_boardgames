# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Game, type: :model do
  let(:game) { create(:game) }

  context 'when creates' do
    it { expect(game.participants.count).to be(1) }
    it { expect(game.creator).to eq(game.participants.first.user) }
    it { expect(game.winner).to be_blank }
    it { expect(game.name).to be_present }
    it { expect(game.members).to be_present }
  end

  describe '#destroy' do
    it 'destroys releted participants' do
      create(:participant, game_id: game.id)
      create(:participant, game_id: game.id)
      create(:participant, game_id: game.id)

      expect { game.destroy }.to(
        change { game.participants.count }.from(4).to(0)
      )
    end

    it 'destroys reletaed gameinvites' do
      user = create(:user)
      game.creator.send_game_invite(user, game)

      expect { game.destroy }.to(
        change { game.game_invites.count }.from(1).to(0)
      )
    end

    it 'destroys with winner' do
      participant = create(:participant, game_id: game.id)
      game.update(winner: participant)
      expect(game.destroy).to be_truthy
    end
  end

  describe '#update' do
    it 'update when valid' do
      expect { game.update(name: 'Fief') }.to(
        change { game.name }.from(game.name).to('Fief')
      )
    end

    it 'update when not valid' do
      expect(game.update(name: '')).to be_falsey
    end
  end
end
