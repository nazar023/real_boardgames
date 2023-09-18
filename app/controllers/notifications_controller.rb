# frozen_string_literal: true

class NotificationsController < ApplicationController # :nodoc:
  include ActionView::RecordIdentifier

  before_action :authenticate_user!

  # def destroy
  #   @game = @notification.params[:message].game
  #   @user = @game.creator
  #   @notifications = @user.notifications.newest_first

  #   respond_to do |format|
  #     format.turbo_stream if @notification.destroy
  #   end
  # end

  def create_user_invite
    @notification = GameInvite.create!(user_invite_params)
    @user = @notification.sender
    @game = @notification.game
    @eligible_friends = []

    @eligible_friends = @user.find_eligible_friends_for_game(@game) if @user

    respond_to do |format|
      if @notification
        update_notification_counter
        send_notification_to_receiver
        remove_notification_possibility_for_users
        format.turbo_stream
        # format.html { redirect_to @notification.game, notice: "Successfully send to #{@notification.receiver.username}" }
      end
    end

  end

  def accept_invite
    @notification = GameInvite.find(params[:id])
    @user = @notification.receiver
    @game = @notification.game

    @participant = @notification.accept

    respond_to do |format|
      if @participant
        format.html { redirect_to @game, notice: 'Successfully accepted invite', data: { turbo: false } }
        participants_list_stream
        win_selector_stream
        game_member_counter_stream
      else
        redirect_to Game, alert: 'Game already full or end'
      end
    end
  end

  def decline_invite
    @notification = GameInvite.find(params[:id])
    @user = @notification.receiver
    @game = @notification.game

    respond_to do |format|
      if @notification.decline
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
    @notification = Friendship.new params.required(:friendship).permit(:receiver_id, :sender_id)
    @notification.pending!
    @user = @notification.receiver

    respond_to do |format|
      if @notification.save
        send_notification_to_receiver
        update_notification_counter
        format.html { redirect_to "/id/#{@user.id}", notice: 'Friend request was successfully send', data: { turbo: false } }
      end
    end
  end

  def accept_friendship
    @notification = Friendship.find(params[:id])
    @user = @notification.receiver

    authorize @user, :user?

    @notification.accept

    respond_to do |format|
      if @notification.accepted?
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
    @notification = Friendship.find(params[:id])
    @user = @notification.receiver

    authorize @user, :user?

    @notification.decline

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          update_local_notification_counter,
          remove_user_notification
        ]
      end
    end
  end

  private

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
    Turbo::StreamsChannel.broadcast_append_to "#{dom_id(@notification.receiver)}_notifications", target: 'notifications', partial: "notifications/notification_classifying", locals: { notification: @notification }
  end

  def update_notification_counter
    Turbo::StreamsChannel.broadcast_update_to "#{dom_id(@notification.receiver)}_notifications", target: 'notification_counter', html: @notification.receiver.notifications.count
  end

  def update_local_notification_counter
    turbo_stream.update 'notification_counter', html: @user.notifications.count
  end

  def remove_user_notification
    turbo_stream.remove "#{dom_id(@notification)}_notification"
  end

  def add_new_friendship_to_list
    Turbo::StreamsChannel.broadcast_append_to "#{dom_id(@notification.receiver)}_friendships", target: "friendships", partial: "friendships/friendship", locals: { friendship: @notification, user: @user }
  end

  def add_notification_possibility_for_users
    @notification.receiver.friends_who_participates_in_game(@game).each do |id|
      user = User.find(id)
      Turbo::StreamsChannel.broadcast_replace_to "#{dom_id(@game)}_#{dom_id(user)}_friends", target: "#{dom_id(user)}_friends", partial: "games/notifications/invite_friends", locals: { user: user, friends: user.find_eligible_friends_for_game(@game), game: @game }
    end
  end

  def remove_notification_possibility_for_users
    @notification.receiver.friends_who_participates_in_game(@game).each do |id|
      user = User.find(id)
      Turbo::StreamsChannel.broadcast_remove_to "#{dom_id(@game)}_#{dom_id(user)}_friends", target: "#{dom_id(@notification.receiver)}"
    end
  end

  def user_invite_params
    params.require(:game_invite).permit(:sender_id, :receiver_id, :game_id, :desc)
  end

  def full?(game)
    game.participants.count >= game.members
  end

end
