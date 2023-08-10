# frozen_string_literal: true

class ProfilesController < ApplicationController # :nodoc:

  def show
    @user = User.find(params[:id])
    @winrate = (@user.wins_count / Float(@user.games_count)) * 100

    @friends = @user.friends
    @friends_reqs = @user.friends_reqs

    return unless params[:query].present?

    @users = User.where('username LIKE ?', "#{params[:query].squish}%").or(User.where(number: "#{params[:query]}"))
  end

end
