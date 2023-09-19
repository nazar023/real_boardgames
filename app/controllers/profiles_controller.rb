# frozen_string_literal: true

class ProfilesController < ApplicationController # :nodoc:
  before_action :set_user

  def show

    @winrate = @user.winrate
    @friends = @user.friendships
    @requests = @user.friendships_reqs

    return unless current_user == @user

    @notifications = @user.notifications

    return unless params[:query].present?

    @users = User.where('username LIKE ?', "#{params[:query].squish}%").or(User.where(number: "#{params[:query]}"))
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
