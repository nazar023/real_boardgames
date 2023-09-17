# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GameInvite, type: :model do
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
  end
end
