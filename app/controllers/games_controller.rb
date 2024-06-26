# frozen_string_literal: true

class GamesController < ApplicationController # :nodoc:
  include ActionView::RecordIdentifier
  before_action :authenticate_user, only: %i[new edit create update destroy]
  before_action :set_game, only: %i[show edit update destroy winner create_user_invite choose_winner]
  # GET /games or /games.json
  def index
    authorize Game
    @games = Game.all.with_participants.on_going
    @user = current_user
  end

  # GET /games/1 or /games/1.json
  def show
    authorize @game
    @participants = @game.participants.includes(user: :avatar_attachment)

    return unless current_user

    @user = current_user
    @eligible_friends = @user.find_eligible_friends_for_game(@game) if current_user
  end

  # GET /games/new
  def new
    authorize Game
    authorize current_user, :has_number?
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
    @user = current_user

    respond_to do |format|
      if @game.save && verify_recaptcha(model: @game)
        # format.turbo_stream
        format.html { redirect_to game_url(@game), notice: 'Game was successfully created.' }
        # format.turbo_stream
        broadcast_new_game
        format.json { render :show, status: :created, location: @game }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  def choose_winner
    winner = Participant.find(game_params[:winner_id])
    @game.finish(winner)

    respond_to do |format|
      if @game.save
        broadcast_updated_info
        broadcast_winner_info
        hide_joining_win_selector
        format.turbo_stream
      end
    end
  end
  # PATCH/PUT /games/1 or /games/1.json
  def update
    authorize @game

    respond_to do |format|
      if @game.update(game_params) && @game.save
        broadcast_updated_info
        format.html { redirect_to game_url(@game), notice: 'Game was successfully updated.' }
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
    respond_to do |format|
      broadcast_game_remove
      format.html { redirect_to games_url, notice: 'Game was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def broadcast_new_game
    Turbo::StreamsChannel.broadcast_prepend_to 'games', target: 'games-list', partial: 'games/game', locals: { game: @game, user: current_user}
  end

  def broadcast_updated_info
    Turbo::StreamsChannel.broadcast_replace_to 'games', target: "game_#{@game.id}", partial: 'games/game', locals: { game: @game, user: current_user }
  end

  def broadcast_winner_info
    Turbo::StreamsChannel.broadcast_replace_to "#{dom_id(@game)}", target: 'winner', partial: '/participants/winner', locals: { winner: @game.winner }
  end

  def hide_joining_win_selector
    Turbo::StreamsChannel.broadcast_remove_to "#{dom_id(@game)}", target: 'joining'
    Turbo::StreamsChannel.broadcast_remove_to "#{dom_id(@game)}", target: 'win_selector'
  end

  def broadcast_game_remove
    Turbo::StreamsChannel.broadcast_remove_to 'games', target: "#{dom_id(@game)}"
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_game
    @game = Game.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def game_params
    params.require(:game).permit(:winner_id, :name, :desc, :members)
  end

  def user_invite_params
    params.require(:game_invite).permit(:sender_id, :receiver_id, :game_id, :desc)
  end

  def authenticate_user
    return if user_signed_in?

    redirect_to new_session_path, status: :found, alert: 'You must be loged in to perform this action'
  end
end
