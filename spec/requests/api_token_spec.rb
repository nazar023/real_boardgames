require 'rails_helper'

RSpec.describe ApiToken, type: :model do
  let(:api_token) { create(:api_token) }

  context 'validations' do
    subject { api_token }
    it { should validate_presence_of(:token) }
    it { should belong_to(:user) }
  end
end
