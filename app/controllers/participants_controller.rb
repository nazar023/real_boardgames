# frozen_string_literal: true

class ParticipantsController < ApplicationController # :nodoc:
  before_action :set_game

  def create
    authorize @game, :full?
    @participant = @game.participants.new(participant_params)
    @user = current_user

    @eligible_friends = @user.find_eligible_friends_for_game(@game) if current_user

    respond_to do |format|
      if @participant.save
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
