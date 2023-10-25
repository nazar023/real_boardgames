# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Game, type: :model do
  let(:game) { create(:game) }

  context 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:members) }
  end

  context 'associations' do
    it { is_expected.to have_many(:participants) }
    it { is_expected.to have_many(:game_invites) }
    it { is_expected.to belong_to(:creator).class_name('User') }
  end

  it "creates creator's participant on create" do
    game = build(:game)
    expect(game.participants.count).to be(0)

    expect { game.save }.to(
      change { game.participants.count }.from(0).to(1)
    )
    expect(game.participants.first.user).to eq(game.creator)
  end

  it { expect(game.winner).to be_blank }

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

  describe '#finish' do
    it 'add winner to game' do
      participant = create(:participant, game:)

      expect { game.finish(participant) }.to(
        change { game.winner }.from(nil).to(participant)
      )
    end

    it 'increases game counter for all user participants' do
      game.creator

      expect { game.finish(game.participants.first) }.to(
        change { User.first.games_count }.from(0).to(1)
      )
    end

    it 'destroys game invites' do
      game_invite = create(:game_invite)
      game = game_invite.game
      participant = create(:participant, game:)

      expect { game.finish(participant) }.to(
        change { GameInvite.count }.from(1).to(0)
      )
    end
  end
end
