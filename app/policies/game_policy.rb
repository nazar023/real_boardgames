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
    creator?
  end

  def destroy?
    update?
  end

  private

  def creator?
    user == record.creator
  end

end
