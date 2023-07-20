class ProfilesController < ApplicationController

  def new
    @user = current_user
    @profile = Profile.new
  end

  def show
    @user = User.find(params[:user_id])
    @profile = @user.profile
  end

  private

  def set_profile
    @profile = current_user.profile
  end

  def set_user
    @user = current_user
  end

end