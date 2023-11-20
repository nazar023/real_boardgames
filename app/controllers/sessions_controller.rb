# frozen_string_literal: true

class SessionsController < ApplicationController # :nodoc:

  def new
    redirect_to games_path, alert: "Don't play with me :)" if current_user
  end

  def create
    redirect_to games_path, alert: "Don't play with me :)" if current_user

    if user = User.authenticate_by(email: params[:email], password: params[:password])
      login user
      redirect_to home_path
    else
      flash[:alert] = 'Wrong email or password'
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout current_user
    flash[:notice] = 'Signed out successfully'
    redirect_to home_path
  end
end
