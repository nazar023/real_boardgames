# frozen_string_literal: true

class ParticipantsController < ApplicationController # :nodoc:
  before_action :set_game

  def create
    authorize @game, :full?
    @participant = @game.participants.new(participant_params)
    @user = current_user

    if current_user
      friendships = (@user.friendships.pluck(:receiver_id) + @user.friendships.pluck(:sender_id)).uniq
      friendships.delete(@user.id)
      participants_users_ids = @game.participants.pluck(:user_id).compact
      friendships -= participants_users_ids
      invited_to_game = GameInvite.where(game_id: @game.id).pluck(:receiver_id)
      friendships -= invited_to_game
      @eligible_friends = @user.friendships.where(receiver_id: friendships).or(@user.friendships.where(sender_id: friendships))
    end

    respond_to do |format|
      if @participant.save
        format.turbo_stream
        format.json { render :show, status: :created, location: @game }
      else
        format.turbo_stream
        format.html { redirect_to @game, status: :unprocessable_entity, alert: "Can't join this game, number and username can't be blank" }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_game
    @game = Game.find(params[:id])
  end

  def participant_params
    params.required(:participant).permit(:game_id, :user_id, :name, :number)
  end
end
