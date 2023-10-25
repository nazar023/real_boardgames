# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApiToken, type: :model do
  context 'validations' do
    it { is_expected.to belong_to(:user) }
  end

  it 'generates token before validation' do
    subject.token = nil
    expect(subject.token).to be_nil

    expect(subject.valid?).to be(false)
    expect(subject.errors.messages.keys).not_to include(:token)
    expect(subject.token).to_not be_empty
  end
end
