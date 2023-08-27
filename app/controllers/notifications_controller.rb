# frozen_string_literal: true

class NotificationsController < ApplicationController # :nodoc:
  before_action :set_notification

  def destroy
    @game = @notification.params[:message].game
    @user = @game.creator
    @notifications = @user.notifications.newest_first

    respond_to do |format|
      format.turbo_stream if @notification.destroy
    end
  end

  private

  def set_notification
    @notification = Notification.find(params[:id])
  end
end
