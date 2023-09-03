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
        change { Friend.count }.from(2).to(0)
      )
    end

    # it '
  end


end

# Homework
# - New router (maybe Nazar support)
# !!! more tests (begin with test, before create model)
# ?-? SQL
# - enum
