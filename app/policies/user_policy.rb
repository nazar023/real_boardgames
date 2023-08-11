# frozen_string_literal: true

class UserPolicy < ApplicationPolicy # :nodoc:

  def friends?
    user &&
      user != record &&
      record.friends.find_by(whoSent_id: user.id, user_id: record.id).blank? &&
      user.friends.find_by(whoSent_id: record.id, user_id: user.id).blank?
  end

end
