# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Profiles', type: :request do
  let(:profile) { create(:profile) }

  describe 'GET /profiles/:user_id' do
    it 'returns http success' do
      get "/profiles/#{profile.user_id}"
      expect(response).to have_http_status(:success)
    end
  end
end
