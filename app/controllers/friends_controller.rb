# frozen_string_literal: true

class FriendsController < ApplicationController # :nodoc:
  before_action :set_profile, only: [ :create ]

  def create
    request = Friend.create! params.required(:friend).permit(:user_id, :whoSent_id, :request)

    redirect_to @user, notice: 'Friend request was successfully send' if request.save

  end

  def update
    @request = Friend.find(params[:id])
    user = User.find(@request.user_id)

    if params[:friend][:request] == 'true'
      @request.request = false
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
