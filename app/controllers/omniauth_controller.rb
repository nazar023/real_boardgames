# frozen_string_literal: true

class OmniauthController < ApplicationController # :nodoc:
  require 'open-uri'

  def discord
    auth_hash = request.env['omniauth.auth']
    login_omniauth auth_hash

    redirect_to root_path, notice: 'Signed in successfully'
  end

  def github
    auth_hash = request.env['omniauth.auth']
    login_omniauth auth_hash

    redirect_to root_path, notice: 'Signed in successfully'
  end

  def oauth_failure
    redirect_to root_path, alert: 'Something went wrong', status: :found
  end
end
