# frozen_string_literal: true

class NotificationsController < ApplicationController # :nodoc:
  before_action :set_notification, except: %i[ create_user_invite ]

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
    @user = @invite.whoSent
    @eligible_friends = []

    invited_to_game = GameInvite.where(game_id: @invite.game_id).map(&:whoGet_id)
    participants_users_ids = @invite.game.participants.map(&:user_id)
    user_friends_reqs = @user.friends_reqs.where(request: true).pluck(:whoSent_id) + @user.friends.where(request: true).pluck(:user_id)

    @not_eligible = (invited_to_game + participants_users_ids + user_friends_reqs).compact.uniq

    @eligible_friends = @user.friends.where.not(user_id: @not_eligible).with_users_avatars + @user.friends_reqs.where.not(whoSent_id: @not_eligible).with_users_avatars

    respond_to do |format|
      if @invite
        format.turbo_stream
        format.html { redirect_to @invite.game, notice: "Successfully send to #{@invite.whoGet.username}" }
      end
    end

  end

  def accept_invite
    game_invite = @notification.to_notification.params[:message]
    user = game_invite.whoGet
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
    @user = game_invite.whoGet
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
    params.require(:game_invite).permit(:whoSent_id, :whoGet_id, :game_id, :desc)
  end

  def full?(game)
    game.participants.count >= game.members
  end

end
