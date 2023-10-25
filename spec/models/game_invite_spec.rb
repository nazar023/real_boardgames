# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GameInvite, type: :model do
  context 'validations' do
    it { is_expected.to belong_to(:receiver).class_name('User') }
    it { is_expected.to belong_to(:sender).class_name('User') }
    it { is_expected.to belong_to(:game).class_name('Game') }
  end

  describe '#accept' do
    it 'makes receiver a game participant' do
      invite = create(:game_invite)

      expect { invite.accept }.to(
        change { Participant.count }.from(1).to(2)
      )
    end

    it 'does not create participant when game is full' do
      game = create(:game, members: 4)
      create_list(:participant, 3, game:)
      expect(game.participants.count).to be(4)

      invite = create(:game_invite, game:)
      expect(invite.accept).to be_nil
    end
  end

  context '#decline' do
    it 'destroys game invite' do
      invite = create(:game_invite)
      expect { invite.decline }.to(
        change { GameInvite.count }.from(1).to(0)
      )
    end
  end
end
