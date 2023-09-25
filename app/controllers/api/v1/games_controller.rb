# frozen_string_literal: true

module Api
  module V1
    class GamesController < BaseController # :nodoc:

      def index
        games = Game.all.with_participants
        render json: games
      end

      def show
        game = Game.find(params[:id])
        render json: game, include: [:participants, :creator]
      end

    end
  end
end
