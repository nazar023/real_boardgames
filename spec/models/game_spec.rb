# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Game, type: :model do
  let(:game) { create(:game) }

  context 'when creates' do
    subject { game }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:members) }
    it { should have_many(:participants) }
    it { expect(game.participants.count).to be(1) }
    it { expect(game.creator).to eq(game.participants.first.user) }
    it { expect(game.winner).to be_blank }
  end

  describe '#destroy' do
    it 'destroys releted participants' do
      create(:participant, game:)
      create(:participant, game:)
      create(:participant, game:)

      expect { game.destroy }.to(
        change { Participant.count }.from(4).to(0)
      )
    end

    it 'destroys reletaed game invites' do
      create(:game_invite, game:)

      expect { game.destroy }.to(
        change { GameInvite.count }.from(1).to(0)
      )
    end

    it 'destroys with winner' do
      participant = create(:participant, game:)
      game.update!(winner: participant)

      expect { game.destroy }.not_to raise_error
      expect(Game.count).to eq(0)
    end
  end

  # try shoulda_matchers gem instead
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
