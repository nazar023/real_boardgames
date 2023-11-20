# frozen_string_literal: true

class RegistrationsController < ApplicationController # :nodoc:
  before_action :set_user, only: %i[edit update destroy]

  def new
    redirect_to games_path, alert: "Don't play with me :)", status: :found if current_user

    @user = User.new
  end

  def create
    redirect_to games_path, alert: "Don't play with me :)", status: :found if current_user

    @user = User.new(registraion_params)
    if @user.save
      login @user
      redirect_to "/id/#{@user.id}", notice: "Signed up successfully"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @user
  end

  def update
    authorize @user
    if @user.update(updating_params) && @user.save
      redirect_to "/id/#{@user.id}", notice: "Updated successfully"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @user

    if @user.destroy
      redirect_to games_path, satatus: :success
    end

  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def registraion_params
    params.require(:user).permit(:email, :password, :password_confirmation, :username, :number, :avatar)
  end

  def updating_params
    params.require(:user).permit(:email, :username, :number, :avatar)
  end

end
