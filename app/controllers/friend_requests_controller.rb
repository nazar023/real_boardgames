# frozen_string_literal: true

class FriendRequestsController < ApplicationController # :nodoc:
  before_action :set_profile, only: [:create]
  before_action :set_request, only: [:destroy]

  def create
    @f_request = @profile.friend_requests.create! params.required(:friend_request).permit(:profile_id, :username, :friend_id, :number)

    @f_request.avatar.attach(current_user.avatar_blob) if User.find(current_user.id).avatar.attached?

    redirect_to @profile, notice: 'Friend request was successfully send' if @f_request.save
  end

  def destroy
    redirect_to "/profiles/#{@profile.id}", notice: 'Friend request was successfully declined' if @f_request.destroy
  end

  private

  def set_profile
    @profile = Profile.find(params[:friend_request][:profile_id])
  end

  def set_request
    @f_request = FriendRequest.find(params[:id])
    @profile = Profile.find(@f_request.profile_id)
  end
end
