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
    creator? && winner_present?
  end

  def destroy?
    creator?
  end

  def full?
    record.participants.length
  end

  def choose_winner?
     amount_participants > 1 && winner_present?
  end

  private

  def creator?
    user == record.creator
  end

  def winner_present?
    record.winner_id.blank?
  end

  def amount_participants
    record.participants.length
  end

end
