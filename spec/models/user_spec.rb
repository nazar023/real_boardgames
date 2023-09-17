# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User', type: :model do
  describe 'validations' do
    subject { create(:user) }
    it { should validate_presence_of(:username) }
    it { should validate_presence_of(:number) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
    it { should have_many(:games) }
    it { should have_many(:participants) }
    it { should have_many(:friendships) }
    it { should have_many(:friendships_reqs) }
    it { should have_many(:friendships_send) }
    it { should have_many(:game_invites) }
  end

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
end

# Homework
# - New router (maybe Nazar support)
# !!! more tests (begin with test, before create model)
# ?-? SQL
# - enum
