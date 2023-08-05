# frozen_string_literal: true

class ProfilesController < ApplicationController # :nodoc:

  def show
    @user = User.find(params[:id])
    @friends = @user.friends
    @winrate = (@user.wins_count / Float(@user.games_count)) * 100

    return unless params[:query].present?

    @users = User.where('username LIKE ?', "#{params[:query].squish}%").or(User.where(number: "#{params[:query]}"))
  end

end
