# frozen_string_literal: true

class GamesController < ApplicationController # :nodoc:
  before_action :authenticate_user!, only: %i[new edit create update destroy]
  before_action :set_game, only: %i[show edit update destroy winner create_user_invite choose_winner]
  # GET /games or /games.json
  def index
    authorize Game
    @games = Game.all.with_participants
    @user = current_user
    return unless current_user

    current_user.notifications.mark_as_read!
    @notifications = current_user.notifications.newest_first
  end

  # GET /games/1 or /games/1.json
  def show
    authorize @game
    @participants = @game.participants.includes(user: :avatar_attachment)

    return unless current_user

    @user = current_user

    if current_user
      friends = (@user.friends.pluck(:receiver_id) + @user.friends.pluck(:sender_id)).uniq
      friends.delete(@user.id)
      participants_users_ids = @game.participants.pluck(:user_id).compact
      friends -= participants_users_ids
      invited_to_game = GameInvite.where(game_id: @game.id).pluck(:receiver_id)
      friends -= invited_to_game
      @eligible_friends = @user.friends.where(receiver_id: friends).or(@user.friends.where(sender_id: friends))
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

    respond_to do |format|
      if @game.save
        format.html { redirect_to game_url(@game), notice: 'Game was successfully created.' }
        format.json { render :show, status: :created, location: @game }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  def choose_winner
    return unless game_params[:winner_id].present?

    @game.winner_id = game_params[:winner_id]

    @winner = @game.participants.find(game_params[:winner_id])

    if @winner.user_id.present?
      @user_winner = User.find(@winner.user_id)
      @user_winner.increment(:wins_count, 1).save if @winner.user_id.present?
    end

    users = @game.participants.where.not(user_id: nil)

    users.each do |user|
      User.find(user.user_id).increment(:games_count, 1).save
    end

    respond_to do |format|
      if @game.save
        format.turbo_stream
      end
    end
  end
  # PATCH/PUT /games/1 or /games/1.json
  def update
    authorize @game

    respond_to do |format|
      if @game.update(game_params) && @game.save
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
    users = (@game.participants.pluck(:user_id) + @game.game_invites.pluck(:receiver_id)).compact.map { |id| User.find(id) }

    users.each do |user|
      user.notifications.each do |notification|
        params = notification.to_notification
        notification.destroy if params.params[:message].game == @game
      end
    end

    @game.destroy
    respond_to do |format|
      format.html { redirect_to games_url, notice: 'Game was successfully destroyed.' }
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

  def user_invite_params
    params.require(:game_invite).permit(:sender_id, :receiver_id, :game_id, :desc)
  end
end
