# frozen_string_literal: true

class ApplicationController < ActionController::Base # :nodoc:
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def authenticate_user!
    redirect_to root_path, alert: 'Log in to perform this action' unless user_signed_in?
  end

  def login(user)
    Current.user = user
    reset_session
    cookies.encrypted[:user_id] = user.id
    session[:user_id] = user.id
  end

  def login_omniauth(auth_hash)
    provider = auth_hash.provider

    email = auth_hash.info.email
    oauth_failure unless email

    @user = User.find_or_create_by(email:)

    unless @user.persisted?
      case provider
      when 'discord'
        assign_user_variables(auth_hash.info.name, auth_hash.info.image)
      when 'github'
        assign_user_variables(auth_hash.info.nickname, auth_hash.info.image)
      else
        oauth_failure
      end
    end

    login @user
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
    redirect_back(fallback_location: root_path)
  end

  def assign_user_variables(username, url)
    @user.username = username
    @user.password = Digest::MD5.hexdigest(SecureRandom.hex)

    if url.present?
      downloaded_image = URI.parse(url).open
      @user.avatar.attach(io: downloaded_image, filename: 'foo.jpg')
    end

    oauth_failure unless @user.save
  end

  def oauth_failure
    redirect_to root_path, alert: 'Something went wrong', status: :found
  end

end
