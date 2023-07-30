# frozen_string_literal: true

class GamesController < ApplicationController # :nodoc:
  before_action :authenticate_user!, only: %i[new edit create update destroy]
  before_action :set_game, only: %i[show edit update destroy winner]
  # GET /games or /games.json
  def index
    authorize Game
    @games = Game.all
  end

  # GET /games/1 or /games/1.json
  def show
    authorize @game

    if @game.winner_id.present?
      @winner = @game.participants.find(@game.winner_id)
    end
  end

  # GET /games/new
  def new
    authorize Game
    @game = Game.new
  end

  # GET /games/1/edit
  def edit
    authorize @game
  end

  # POST /games or /games.json
  def create
    authorize Game
    @game = Game.new(game_params)
    @game.creator = current_user
    @creator = @game.participants.new(profile: @game.creator.id, name: @game.creator.username,
                                      number: @game.creator.number, avatar: @game.creator.avatar_blob)
    @creator.save

    respond_to do |format|
      if @game.save
        format.html { redirect_to game_url(@game), notice: "Game was successfully created." }
        format.json { render :show, status: :created, location: @game }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /games/1 or /games/1.json
  def update
    authorize @game

    if game_params[:winner_id].present?
      @game.winner_id = game_params[:winner_id]
      @winner = @game.participants.find(game_params[:winner_id])

      Profile.find(@winner.profile).increment(:wins, 1).save if @winner.profile.present?

      users = @game.participants.where.not(profile: nil)

      users.each do |user|
        Profile.find(user.profile).increment(:games, 1).save
      end
    end

    respond_to do |format|
      if @game.update(game_params) && @game.save
        format.html { redirect_to game_url(@game), notice: "Game was successfully updated." }
        format.json { render :show, status: :ok, location: @game }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1 or /games/1.json
  def destroy
    authorize @game
    @game.destroy

    @game.participants.each do |one|
      one.destroy
    end

    respond_to do |format|
      format.html { redirect_to games_url, notice: "Game was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_game
    @game = Game.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def game_params
    params.require(:game).permit(:winner_id, :name, :desc, :members)
  end
end
