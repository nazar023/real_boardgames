# frozen_string_literal: true

class OmniauthController < ApplicationController # :nodoc:
  require 'open-uri'

  def discord
    auth_hash = request.env['omniauth.auth']
    email = auth_hash.info.email
    @user = User.find_or_create_by(email:)

    unless @user.persisted?
      assign_user_variables(auth_hash.info.name, auth_hash.info.image)
      oauth_failure unless @user.save
    end

    login @user
    redirect_to home_path, notice: 'Signed in successfully'
  end

  def github
    auth_hash = request.env['omniauth.auth']
    email = auth_hash.info.email
    @user = User.find_or_create_by(email:)

    unless @user.persisted?
      assign_user_variables(auth_hash.info.nickname, auth_hash.info.image)
      oauth_failure unless @user.save
    end

    login @user
    redirect_to home_path, notice: 'Signed in successfully'
  end

  def oauth_failure
    redirect_to home_path, alert: 'Something went wrong', status: :found
  end

  private

  def assign_user_variables(username, url)
    downloaded_image = URI.parse(url).open
    @user.username = username
    @user.avatar.attach(io: downloaded_image, filename: 'foo.jpg')
    @user.password = Digest::MD5.hexdigest(SecureRandom.hex)
  end
end
