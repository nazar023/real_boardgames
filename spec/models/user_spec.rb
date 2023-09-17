# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User', type: :model do
  describe '#destroy' do
    it 'destroys related friendships' do
      user = create(:user)
      create(:friendship, receiver: user)
      create(:friendship, sender: user)

      expect { user.destroy }.to(
        change { Friendship.count }.from(2).to(0)
      )
    end

    it 'destroys related games' do
      game = create(:game)
      user = game.creator

      expect { user.destroy }.to(
        change { Game.count }.from(1).to(0)
      )
    end

    it 'destroys related game invite' do
      game = create(:game)
      creator = game.creator
      user = create(:user)

      create(:game_invite, sender: creator, receiver: user)
      other_game_invite = create(:game_invite, sender: creator)

      expect { user.destroy }.to(
        change { GameInvite.count }.from(2).to(1)
      )

      expect(GameInvite.pluck(:id)).to eq([other_game_invite.id])
    end
  end

  # try shoulda_matchers
  describe '#update' do
    it 'updates user' do

      user = create(:user)
      username = user.username
      expect { user.update(username: 'James B0nd') }.to(
        change { user.username }.from(username).to('James B0nd')
      )
    end
  end

  describe '#accept_game_invite' do
    it "makes this user a game participant" do
      invite = create(:game_invite)
      user = invite.receiver

      invite.accept
    end
  end
end

# Homework
# - New router (maybe Nazar support)
# !!! more tests (begin with test, before create model)
# ?-? SQL
# - enum
