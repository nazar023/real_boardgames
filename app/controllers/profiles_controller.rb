# frozen_string_literal: true

class ProfilesController < ApplicationController # :nodoc:

  def show
    @user = User.find(params[:id])
    @winrate = (@user.wins_count / Float(@user.games_count)) * 100

    # friends = @user.friends.where(request: false).includes(user: :avatar_attachment)
    # friends_reqs = @user.friends_reqs.where(request: false).includes(whoSent: :avatar_attachment)

    @friends = @user.friends.where(request: false).includes(user: :avatar_attachment) +
               @user.friends_reqs.where(request: false).includes(whoSent: :avatar_attachment)

    @requests = @user.friends.where(request: true).includes(whoSent: :avatar_attachment)

    return unless params[:query].present?

    @users = User.where('username LIKE ?', "#{params[:query].squish}%").or(User.where(number: "#{params[:query]}"))
  end

end
