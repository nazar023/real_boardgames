# frozen_string_literal: true

class ProfilesController < ApplicationController # :nodoc:

  def show
    @user = User.find(params[:id])
    @winrate = ((@user.wins_count / Float(@user.games_count)) * 100).round(1)

    @friends = @user.friends.not_request.with_users_avatars + @user.friends_reqs.not_request.with_users_avatars

    @requests = @user.friends_reqs.where.not(sender_id: @user.id)

    return unless params[:query].present?

    @users = User.where('username LIKE ?', "#{params[:query].squish}%").or(User.where(number: "#{params[:query]}"))
  end

end
