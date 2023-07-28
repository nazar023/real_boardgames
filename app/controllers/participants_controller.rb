# frozen_string_literal: true

class ParticipantsController < ApplicationController # :nodoc:
  before_action :set_game

  def create
    @participant = @game.participants.create! params.required(:participant).permit(:profile ,:name, :number)

    if current_user.number == @participant.number && current_user&.avatar&.attached?
      @participant.avatar.attach(current_user.avatar_blob)
    end
    redirect_to @game
  end

  private

  def set_game
    @game = Game.find(params[:game_id])
  end
end
