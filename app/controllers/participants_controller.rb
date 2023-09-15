# frozen_string_literal: true

class ParticipantsController < ApplicationController # :nodoc:
  before_action :set_game

  def create
    authorize @game, :full?
    @participant = @game.participants.new(participant_params)
    @participant.creator ? @participant.user! : @participant.guest!
    @user = current_user

    @eligible_friends = @user.find_eligible_friends_for_game(@game) if current_user

    respond_to do |format|
      if @participant.save
        format.turbo_stream
      else
        format.turbo_stream
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
end
