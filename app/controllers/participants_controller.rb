# frozen_string_literal: true

class ParticipantsController < ApplicationController # :nodoc:
  before_action :set_game

  def create
    authorize @game, :full?
    @participant = @game.participants.new(participant_params)
    @user = current_user

    if current_user
      invited_to_game = GameInvite.where(game_id: @game.id).map(&:receiver_id)
      participants_users_ids = @game.participants.map(&:user_id)
      user_friends_reqs = @user.friends_reqs.where(request: true).pluck(:sender_id) + @user.friends.where(request: true).pluck(:receiver_id)
      @not_eligible = (invited_to_game + participants_users_ids + user_friends_reqs).compact.uniq
      @eligible_friends = @user.friends.where.not(receiver_id: @not_eligible).with_users_avatars + @user.friends_reqs.where.not(sender_id: @not_eligible).with_users_avatars
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
