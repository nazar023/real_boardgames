# frozen_string_literal: true

class FriendsController < ApplicationController # :nodoc:
  before_action :set_profile, only: [ :create ]

  def create
    request = @user.friends.create! params.required(:friend).permit(:username, :number, :user_id, :whoSent_id, :request)

    request.avatar.attach(current_user.avatar_blob) if User.find(current_user.id).avatar.attached?

    redirect_to @user, notice: 'Friend request was successfully send' if request.save

  end

  def update
    @request = Friend.find(params[:id])
    user = User.find(@request.user_id)

    if params[:friend][:request] == 'true'
      @request.request = false
      who_sent = User.find(@request.whoSent_id)
      friend = who_sent.friends.create!(username: user.username,
                                        number: user.number,
                                        user_id: who_sent.id,
                                        whoSent_id: user.id,
                                        request: false)

      friend.avatar.attach(user.avatar_blob) if user.avatar.attached?

      redirect_to user, notice: 'Friend request was succsesfully accepted' if @request.save
    else
      @request.destroy
      redirect_to user, notice: 'Friend request was succsesfully declined' if @request.save
    end
  end

  private

  def set_profile
    @user = User.find(params[:friend][:user_id])
  end
end
