require 'rails_helper'

RSpec.describe Notification, type: :model do
  it 'deliver notification to creator' do
    game = create(:game)
    creator = game.creator
    create(:participant, game: game)
    create(:participant, game: game)
    create(:participant, game: game)
    expect(creator.notifications.count).to be(3)
  end
end
