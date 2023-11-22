# frozen_string_literal: true

class GamePolicy < ApplicationPolicy # :nodoc:

  def index?
    true
  end

  def show?
    true
  end

  def create?
    true
  end

  def update?
    creator? && winner_blank?
  end

  def destroy?
    creator?
  end

  def full?
    record.participants.count < record.members
  end

  def choose_winner?
     amount_participants > 1 && winner_blank?
  end

  def join?
    # current_user.nil? || game.participants.where(number: current_user.number).blank?
    user.blank? || record.participants.find_by(number: user.number).blank?
  end

  def current_user_participates?
    record.participants.pluck(:user_id).include?(user&.id)
  end

  def finished?
    record.winner.present?
  end

  private

  def creator?
    user == record.creator
  end

  def winner_blank?
    record.winner_id.blank?
  end

  def amount_participants
    record.participants.count
  end

end
