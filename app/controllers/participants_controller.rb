# frozen_string_literal: true

class ParticipantsController < ApplicationController # :nodoc:
  before_action :set_game

  def create
    authorize @game, :full?
    @participant = @game.participants.new(participant_params)

    # if current_user && current_user.number == @participant.number && current_user&.avatar&.attached?
    #   @participant.avatar.attach(current_user.avatar_blob)
    # end
    # redirect_to @game

    respond_to do |format|
      if @participant.save
        if @participant.user
          redirect_to @game
        else
          format.turbo_stream do
            render turbo_stream:
            turbo_stream.append("participants_game_#{@game.id}",
                                partial: 'participants/participant',
                                locals: { game: @game, participant: @participant })
          end
        end
        format.json { render :show, status: :created, location: @game }
      else
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
