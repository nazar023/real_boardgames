# frozen_string_literal: true

class Current < ActiveSupport::CurrentAttributes # :nodoc:
  attribute :user

  def login(user_come)
    Current.user = user_come
    reset_session
    session[:user_id] = user.id
  end

  def logout()
    Current.user = nil
    reset_session
  end

end
