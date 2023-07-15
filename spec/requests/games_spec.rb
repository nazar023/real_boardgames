# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Games', type: :request do
  before do
    @user = User.create!(email: 'jon@snow.com', password: 'i-know-nothing')
    @game = Game.create!(name: 'Fief', members: 5, creator: @user)
  end

  describe 'GET /games/:id' do
    it 'returns http success' do
      get "/games/#{@game.id}"
      expect(response).to have_http_status(200)
    end
  end
end
