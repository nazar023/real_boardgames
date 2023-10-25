# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Friendship, type: :model do
  context 'validations' do
    it { is_expected.to belong_to(:sender).class_name('User') }
    it { is_expected.to belong_to(:receiver).class_name('User') }
  end

  describe '#accept' do
    it 'accepts requests' do
      friendship = create(:friendship)
      receiver = friendship.receiver

      expect { friendship.accept }.to(
        change { receiver.friendships.count }.from(0).to(1)
      )
      expect(receiver.friendships_reqs).to be_blank
    end


  end

end
