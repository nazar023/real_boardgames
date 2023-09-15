# frozen_string_literal: true

class ProfilesController < ApplicationController # :nodoc:

  def show
    @user = User.find(params[:id])
    @winrate = ((@user.wins_count / Float(@user.games_count)) * 100).round(1)

    @friends = @user.friendships
    @requests = @user.friendships_reqs

    return unless current_user == @user

    @notifications = current_user.notifications.newest_first
    current_user.notifications.mark_as_read!

    return unless params[:query].present?

    @users = User.where('username LIKE ?', "#{params[:query].squish}%").or(User.where(number: "#{params[:query]}"))
  end

end
