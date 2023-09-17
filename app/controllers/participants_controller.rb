# frozen_string_literal: true

class ParticipantsController < ApplicationController # :nodoc:
  include ActionView::RecordIdentifier
  before_action :set_game

  def create
    authorize @game, :full?
    @participant = @game.participants.new(participant_params)
    @user = current_user

    @eligible_friends = @user.find_eligible_friends_for_game(@game) if current_user

    respond_to do |format|
      if @participant.save
        participants_list_stream
        win_selector_stream
        game_member_counter_stream
        remove_joining_aside_stream if policy(@game).full? && @game.winner.present?
        remove_user_invite_stream if @participant.user
        remove_join_user_button_stream if @participant.user
        format.turbo_stream do
          render turbo_stream:
          guest_form_frame_tag
        end
      else
        format.turbo_stream do
          render turbo_stream:
          raise_frame_tag_error
        end
      end
    end
  end

  private

  def set_game
    @game = Game.find(params[:id])
  end

  def participant_params
    params.required(:participant).permit(:game_id, :user_id, :name, :number, :created_by, :creator_id)
  end


  def raise_frame_tag_error
    turbo_stream.update('flash_messages', partial: 'layouts/flash_messages', locals: { alert: "Can't join this game, number and username can't be blank"})
  end

  def guest_form_frame_tag
    if @user
      turbo_stream.update 'joining',  partial: 'games/join', locals: { game: @game, user: current_user, friends: @user.find_eligible_friends_for_game(@game) }
    else
      turbo_stream.update 'joining',  partial: 'games/join', locals: { game: @game, user: current_user }
    end
  end

  def guest_form_stream
    if @participant.guest?
      Turbo::StreamsChannel.broadcast_update_to "#{dom_id(@game)}", target: 'guest_form', partial: 'participants/new_guest', locals: { game: @game, participant: Participant.new }
    else
      Turbo::StreamsChannel.broadcast_update_to "#{dom_id(@game)}", target: 'user_guest_form', partial: 'participants/new_guest_user', locals: { user: @participant.creator, game: @game, participant: Participant.new }
    end
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

  def remove_joining_aside_stream
    Turbo::StreamsChannel.broadcast_remove_to "#{dom_id(@game)}", target: 'joining'
  end

  def remove_user_invite_stream
    Turbo::StreamsChannel.broadcast_remove_to "#{dom_id(@game)}", target: "user_#{@participant.user_id}"
  end

  def remove_join_user_button_stream
    Turbo::StreamsChannel.broadcast_remove_to "#{dom_id(@game)}", target: "#{dom_id(@game)}_#{dom_id(@participant.user)}_join_button"
  end
end
