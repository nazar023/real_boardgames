# frozen_string_literal: true

class FriendshipsController < ApplicationController # :nodoc:
  before_action :set_profile, only: [ :create ]

  def create
    request = Friendship.new params.required(:friendship).permit(:receiver_id, :sender_id)
    request.pending!
    if request.save
      redirect_to "/id/#{@user.id}", notice: 'Friend request was successfully send' if request.save
    end
  end

  def update
    @request = Friendship.find(params[:id])
    user = User.find(@request.receiver_id)

    authorize user, :user?


    if params[:friendship][:status] == "1"
      @request.accepted!
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
