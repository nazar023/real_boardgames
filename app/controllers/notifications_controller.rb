# frozen_string_literal: true

class NotificationsController < ApplicationController # :nodoc:
  include ActionView::RecordIdentifier

  before_action :authenticate_user

  def create_user_invite
    @game_invite = GameInvite.create!(user_invite_params)
    @notification = @game_invite.notification
    @user = @game_invite.receiver
    @game = @game_invite.game
    @eligible_friends = []

    @eligible_friends = @user.find_eligible_friends_for_game(@game) if @user

    respond_to do |format|
      if @game_invite
        update_notification_counter
        send_notification_to_receiver
        add_pulsive_element
        remove_notification_possibility_for_users
        format.turbo_stream
        # format.html { redirect_to @game_invite.game, notice: "Successfully send to #{@game_invite.receiver.username}" }
      end
    end

  end

  def accept_invite
    @game_invite = GameInvite.find(params[:id])
    @notification = @game_invite.notification
    @user = @game_invite.receiver
    @game = @game_invite.game

    @participant = @game_invite.accept

    respond_to do |format|
      if @participant
        stream_remove_pulsive_element if @user.notifications.count.zero?
        format.html { redirect_to @game, notice: 'Successfully accepted invite', data: { turbo: false } }
        participants_list_stream
        win_selector_stream
        game_member_counter_stream
      else
        @game_invite.decline
        format.html { redirect_to Game, alert: 'Game already full or end' }
      end
    end
  end

  def decline_invite
    @game_invite = GameInvite.find(params[:id])
    @notification = @game_invite.notification

    @user = @game_invite.receiver
    @game = @game_invite.game

    respond_to do |format|
      if @game_invite.decline
        puts @user.notifications.count
        puts @user.notifications.count.zero?

        stream_remove_pulsive_element if @user.notifications.count.zero?
        format.turbo_stream do
          render turbo_stream: [
            update_local_notification_counter,
            remove_user_notification
          ]
        end
      end
    end
  end

  def send_friendship_request
    @friendship = Friendship.new params.required(:friendship).permit(:receiver_id, :sender_id)
    @friendship.pending!
    @user = @friendship.receiver

    respond_to do |format|
      if @friendship.save
        @notification = @friendship.notification
        send_notification_to_receiver
        update_notification_counter
        add_pulsive_element
        format.html { redirect_to "/id/#{@user.id}", notice: 'Friend request was successfully send', data: { turbo: false } }
      end
    end
  end

  def accept_friendship
    @friendship = Friendship.find(params[:id])
    @notification = @friendship.notification
    @user = @friendship.receiver

    authorize @user, :user?

    @friendship.accept

    respond_to do |format|
      if @friendship.accepted?
        stream_remove_pulsive_element if @user.notifications.count.zero?
        format.turbo_stream do
          render turbo_stream: [
            remove_user_notification,
            update_local_notification_counter
          ]
        end
        add_new_friendship_to_list
      end
    end
  end

  def decline_friendship
    @friendship = Friendship.find(params[:id])
    @notification = @friendship.notification

    @user = @friendship.receiver

    authorize @user, :user?

    @friendship.decline
    @user = User.find(@friendship.receiver.id)

    respond_to do |format|
      stream_remove_pulsive_element if @user.notifications.count.zero?
      format.turbo_stream do
        render turbo_stream: [
          remove_user_notification,
          update_local_notification_counter
        ]
      end
    end
  end

  private

  def add_pulsive_element
    if @user.notifications.count <= 1
      Turbo::StreamsChannel.broadcast_prepend_to "#{dom_id(@user)}_notifications", target: 'notification_button', partial: 'layouts/pulsive_element'
    end
  end

  def stream_remove_pulsive_element
    Turbo::StreamsChannel.broadcast_remove_to "#{dom_id(@user)}_notifications", target: 'notification_pulsing_element'
  end

  def participants_list_stream
    Turbo::StreamsChannel.broadcast_append_to "#{dom_id(@game)}", target: 'participants', partial: 'participants/participant', locals: { participant: @participant, game: @game }
  end

  def win_selector_stream
    Turbo::StreamsChannel.broadcast_update_to "#{dom_id(@game)}", target: 'win_selector', partial: 'participants/win_selector', locals: { participants: @game.participants , game: @game }
  end

  def game_member_counter_stream
    Turbo::StreamsChannel.broadcast_update_to 'games', target: 'participants_counter', html: @game.participants.count
    Turbo::StreamsChannel.broadcast_update_to "#{dom_id(@game)}", target: 'participants_counter', html: @game.participants.count
  end

  def send_notification_to_receiver
    Turbo::StreamsChannel.broadcast_append_to "#{dom_id(@user)}_notifications", target: 'notifications', partial: "notifications/notification_classifying", locals: { notification: @notification }
  end

  def update_notification_counter
    Turbo::StreamsChannel.broadcast_update_to "#{dom_id(@user)}_notifications", target: 'notification_counter', html: @user.notifications.count
  end

  def update_local_notification_counter
    turbo_stream.update 'notification_counter', html: @user.notifications.count
  end

  def remove_user_notification
    turbo_stream.remove "#{dom_id(@notification)}_notification"
  end

  def add_new_friendship_to_list
    Turbo::StreamsChannel.broadcast_append_to "#{dom_id(@friendship.receiver)}_friendships", target: "friendships", partial: "friendships/friendship", locals: { friendship: @friendship, user: @user }
  end

  def add_notification_possibility_for_users
    @notification.receiver.friends_who_participates_in_game(@game).each do |id|
      user = User.find(id)
      Turbo::StreamsChannel.broadcast_replace_to "#{dom_id(@game)}_#{dom_id(user)}_friends", target: "#{dom_id(user)}_friends", partial: "games/notifications/invite_friends", locals: { user: user, friends: user.find_eligible_friends_for_game(@game), game: @game }
    end
  end

  def remove_notification_possibility_for_users
    @user.friends_who_participates_in_game(@game).each do |id|
      user = User.find(id)
      Turbo::StreamsChannel.broadcast_remove_to "#{dom_id(@game)}_#{dom_id(user)}_friends", target: "#{dom_id(@user)}"
    end
  end

  def user_invite_params
    params.require(:game_invite).permit(:sender_id, :receiver_id, :game_id, :desc)
  end

  def full?(game)
    game.participants.count >= game.members
  end

  def authenticate_user
    return if user_signed_in?

    redirect_to new_session_path, status: :found, alert: 'You must be loged in to perform this action'
  end

end
