class ParticipantsController < ApplicationController
  before_action :set_game

    def create
      @participant = @game.participants.create! params.required(:participant).permit(:name, :number)
      redirect_to @game
    end


  private
    def set_game
      @game = Game.find(params[:game_id])
    end

end
