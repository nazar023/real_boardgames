# frozen_string_literal: true

class ParticipantsController < ApplicationController # :nodoc:
  before_action :set_game

  def create
    authorize @game, :full?
    @participant = @game.participants.create! params.required(:participant).permit(:game_id, :user_id, :name, :number)

    # if current_user && current_user.number == @participant.number && current_user&.avatar&.attached?
    #   @participant.avatar.attach(current_user.avatar_blob)
    # end
    # redirect_to @game
    @participants = @game.participants.includes(user: :avatar_attachment)

    render turbo_stream:
    turbo_stream.replace('participants',
                         partial: 'participants/participant',
                         locals: { game: @game, participants: @participants })
  end

  private

  def set_game
    @game = Game.find(params[:id])
  end
end
