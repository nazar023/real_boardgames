# frozen_string_literal: true

class FriendsController < ApplicationController # :nodoc:
  before_action :set_profile

  def create
    f1 = @profile.friends.create! params.required(:friend).permit(:user_id, :username, :number, :profile_id)

    f2 = @f_profile.friends.create!(user_id: params[:friend][:profile_id],
                                    username: User.find(params[:friend][:profile_id]).username,
                                    number: User.find(params[:friend][:profile_id]).number,
                                    profile_id: params[:friend][:user_id])

    f1.avatar.attach(User.find(@f_profile.id).avatar_blob) if User.find(@f_profile.id).avatar.attached?
    f2.avatar.attach(User.find(@profile.id).avatar_blob) if User.find(@profile.id).avatar.attached?

    redirect_to @profile, notice: 'Congrats with new friend!' if f1.save && f2.save && @request.destroy
  end

  private

  def set_profile
    @profile = Profile.find(params[:profile_id])
    @f_profile = Profile.find(params[:friend][:user_id])
    @request = FriendRequest.find_by(friend_id: params[:friend][:user_id], profile_id: params[:friend][:profile_id])
  end
end
