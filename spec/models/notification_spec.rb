require 'rails_helper'

RSpec.describe 'Notification', type: :model do
  it 'deliver notification to creator' do
    game = create(:game)
    creator = game.creator
    create(:participant, game_id: game.id)
    create(:participant, game_id: game.id)
    create(:participant, game_id: game.id)
    expect(creator.notifications.count).to be(3)
  end

  it 'deliver notification to invited preson' do
    game = create(:game)
    user = create(:user)
    creator = game.creator
    expect { creator.send_game_invite(user, game) }.to(
      change { user.notifications.count }.from(0).to(1)
    )
  end
end
