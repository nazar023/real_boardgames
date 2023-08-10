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
    creator? && winner?
  end

  def destroy?
    creator?
  end

  private

  def creator?
    user == record.creator
  end

  def winner?
    record.winner_id.blank?
  end

end
