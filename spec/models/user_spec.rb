# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User', type: :model do
  # let(:user) { create(:user) }
  # let(:user1) { create(:user) }
  # let(:user2) { create(:user) }
  # let(:game) { create(:game, creator: user) }

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
      other_user = create(:user)
      creator.send_game_invite(user, game)
      creator.send_game_invite(other_user, game)

      expect { user.destroy }.to(
        change { GameInvite.count }.from(2).to(1)
      )
    end
  end

  describe '#update' do
    it 'updates user' do
      user = create(:user)
      username = user.username
      expect { user.update(username: 'James B0nd') }.to(
        change { user.username }.from(username).to('James B0nd')
      )
    end
  end


end

# Homework
# - New router (maybe Nazar support)
# !!! more tests (begin with test, before create model)
# ?-? SQL
# - enum
