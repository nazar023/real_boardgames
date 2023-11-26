# frozen_string_literal: true

class ApplicationController < ActionController::Base # :nodoc:
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized


  def home

  end

  private

  def login(user)
    Current.user = user
    reset_session
    cookies.encrypted[:user_id] = user.id
    session[:user_id] = user.id
  end

  def logout(user)
    Current.user = nil
    reset_session
    cookies.delete(:user_id)
  end

  def current_user
    Current.user ||= authenticate_user_from_session
  end
  helper_method :current_user

  def authenticate_user_from_session
    User.find_by(id: session[:user_id])
  end

  def user_signed_in?
    !!current_user
  end
  helper_method :user_signed_in?


  def user_not_authorized
    flash[:alert] = 'You are not authorized to perform this action.'
    redirect_back(fallback_location: home_path)
  end
end
