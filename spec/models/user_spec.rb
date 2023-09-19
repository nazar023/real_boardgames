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

  describe '#winrate' do
    it 'returns int value' do
      game = create(:game)
      create(:participant, game:)
      participant = create(:participant, game:)
      creator = game.creator
      game.finish(participant)

      expect(creator.winrate.class).to be(Integer)
    end

    it 'return 0 when User has 0 played games' do
      user = create(:user)
      expect(user.winrate).to eq(0)
    end
  end

  describe '#friends_who_participates_in_game' do
    it 'correctly returns friends count' do
      game = create(:game, members: 8)
      creator = game.creator
      friendship1 = create(:friendship, receiver: creator, status: "accepted")
      friendship2 = create(:friendship, receiver: creator, status: "accepted")
      friendship3 = create(:friendship, receiver: creator, status: "accepted")
      create(:participant, user: friendship1.sender, game:)
      create(:participant, user: friendship2.sender, game:)
      create(:participant, user: friendship3.sender, game:)
      create(:participant, game:)
      create(:participant, game:)

      expect(creator.friends_who_participates_in_game(game).count).to eq(3)
    end
  end

  describe '#find_eligible_friends_for_game' do
    it 'correctly filtrates user friends' do
      game = create(:game, members: 8)
      creator = game.creator
      friendship1 = create(:friendship, receiver: creator, status: "accepted")
      friendship2 = create(:friendship, receiver: creator, status: "accepted")
      friendship3 = create(:friendship, receiver: creator, status: "accepted")
      creator.send_game_invite(friendship1.sender, game)
      create(:participant, user: friendship2.sender, game:)

      expect(creator.find_eligible_friends_for_game(game).count).to eq(1)
      expect(creator.find_eligible_friends_for_game(game)).to include(friendship3)
      expect(friendship2.sender.find_eligible_friends_for_game(game).count).to eq(0)
      expect(friendship2.sender.find_eligible_friends_for_game(game)).to be_blank
    end
  end
  # try shoulda_matchers
end

# Homework
# - New router (maybe Nazar support)
# !!! more tests (begin with test, before create model)
# ?-? SQL
# - enum
