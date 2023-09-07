# frozen_string_literal: true

class ProfilesController < ApplicationController # :nodoc:

  def show
    @user = User.find(params[:id])
    @winrate = ((@user.wins_count / Float(@user.games_count)) * 100).round(1)

    @friends = @user.friendships
    # @friends = @user.friends.with_users_avatars + @user.friends_reqs.with_users_avatars

    @requests = @user.friendships_reqs

    return unless params[:query].present?

    @users = User.where('username LIKE ?', "#{params[:query].squish}%").or(User.where(number: "#{params[:query]}"))
  end

end
