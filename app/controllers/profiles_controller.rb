# frozen_string_literal: true

class ProfilesController < ApplicationController # :nodoc:

  def show
    @user = User.find(params[:user_id])
    @profile = @user.profile
    @friends = @profile.friends
    @friend_requests = @profile.friend_requests


    return unless params[:query].present?

    @users = User.where('username LIKE ?', "#{params[:query].squish}%").or(User.where(number: "#{params[:query]}"))
  end

end
