# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GameInvite, type: :model do

  context 'validations' do
    subject { create(:game_invite) }
    it { should belong_to(:receiver).class_name('User') }
    it { should belong_to(:sender).class_name('User') }
    it { should belong_to(:game).class_name('Game') }
  end

  describe '#accept' do
    it 'makes receiver a game participant' do
      invite = create(:game_invite)

      expect { invite.accept }.to(
        change { Participant.count }.from(1).to(2)
      )
    end

    it 'not creates participant when game is full' do
      invite = create(:game_invite)
      game = invite.game
      create(:participant, game:)
      create(:participant, game:)
      create(:participant, game:)
      create(:participant, game:)
      create(:participant, game:)

      expect(invite.accept).to be_nil
    end

    it 'destroys game invite' do
      invite = create(:game_invite)
      expect { invite.decline }.to(
        change { GameInvite.count }.from(1).to(0)
      )
    end
  end
end
