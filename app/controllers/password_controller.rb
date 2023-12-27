# frozen_string_literal: true

class PasswordController < ApplicationController # :nodoc:
  before_action :authenticate_user!
  before_action :set_user

  def edit
    authorize @user
  end

  def update
    authorize @user
    if(@user.update(password_params))
      redirect_to root_path, notice: 'Updated successfully'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def password_params
    params.require(:user).permit(
      :password,
      :password_challenge,
      :password_confirmation
    ).with_defaults(password_challenge: "")
  end

  def set_user
    @user = User.find(params[:id])
  end

end
