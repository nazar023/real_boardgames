# frozen_string_literal: true

class NotificationsController < ApplicationController # :nodoc:
  before_action :set_notification, except: %i[ create_user_invite ]
  before_action :authenticate_user!

  def destroy
    @game = @notification.params[:message].game
    @user = @game.creator
    @notifications = @user.notifications.newest_first

    respond_to do |format|
      format.turbo_stream if @notification.destroy
    end
  end

  def create_user_invite
    @invite = GameInvite.create!(user_invite_params)
    @user = @invite.sender
    @game = @invite.game
    @eligible_friends = []

    @eligible_friends = @user.find_eligible_friends_for_game(@game) if @user

    respond_to do |format|
      if @invite
        format.turbo_stream
        format.html { redirect_to @invite.game, notice: "Successfully send to #{@invite.receiver.username}" }
      end
    end

  end

  def accept_invite
    game_invite = @notification.to_notification.params[:message]
    user = game_invite.receiver
    game = game_invite.game

    if full?(game) && game_invite.destroy && @notification.destroy
      redirect_to Game, alert: 'Game already full or end'
      return
    end

    participant = Participant.new(name: user.username,
                                  number: user.number,
                                  user_id: user.id,
                                  game_id: game.id)

    if participant.save && game_invite.destroy && @notification.destroy
      redirect_to game, notice: 'Successfully accepted invite'
    end
  end

  def decline_invite
    game_invite = @notification.to_notification.params[:message]
    @user = game_invite.receiver
    @notifications = @user.notifications
    respond_to do |format|
      format.turbo_stream  if game_invite.destroy && @notification.destroy
    end
  end

  private

  def set_notification
    @notification = Notification.find(params[:id])
  end

  def user_invite_params
    params.require(:game_invite).permit(:sender_id, :receiver_id, :game_id, :desc)
  end

  def full?(game)
    game.participants.count >= game.members
  end

end
