# frozen_string_literal: true

class FriendsController < ApplicationController # :nodoc:
  before_action :set_profile, only: [ :create ]

  def create
    request = Friend.create! params.required(:friend).permit(:receiver_id, :sender_id, :request)

    redirect_to "/id/#{@user.id}", notice: 'Friend request was successfully send' if request.save

  end

  def update
    @request = Friend.find(params[:id])
    user = User.find(@request.receiver_id)

    if params[:friend][:request] == 'true'
      @request.request = false
      redirect_to "/id/#{user.id}", notice: 'Friend request was succsesfully accepted' if @request.save
    else
      redirect_to "/id/#{user.id}", notice: 'Friend request was succsesfully declined' if @request.destroy
    end
  end

  private

  def set_profile
    @user = User.find(params[:id])
  end
end
