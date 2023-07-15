# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Games', type: :request do
  let(:game) { create(:game) }

  describe 'GET /games/:id' do
    it 'returns http success' do
      get "/games/#{game.id}"
      expect(response).to have_http_status(:success)
    end
  end

  # Mission: create tests for all actions
end

