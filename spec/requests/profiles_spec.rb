require 'rails_helper'

RSpec.describe 'Profiles', type: :request do
let(:user) { create(:user) }


  describe "GET /profiles/:user_id" do
    it 'returns http success' do
      get "/profiles/#{user.id}"
    end
  end
end
