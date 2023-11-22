# frozen_string_literal: true

module Authentication # :nodoc:
  def sign_in(user)
    session = { user_id: user.id }
    allow_any_instance_of(ApplicationController).to receive(:session).and_return(session)
  end

  def logout
    session = { user_id: nil }
    allow_any_instance_of(ApplicationController).to receive(:session).and_return(session)
  end

  def current_user
    session.user_id
  end
end

RSpec.configure do |config|
  config.include Authentication, type: :request
end
