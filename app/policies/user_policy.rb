# frozen_string_literal: true

class UserPolicy < ApplicationPolicy # :nodoc:

  def friends?
    user &&
      user != record &&
      record.friends.find_by(sender_id: record.id, receiver_id: user.id).blank? &&
      user.friends.find_by(sender_id: user.id, receiver_id: record.id).blank?
  end

  def user?
    # current_user == @user && @user.friends.where(request: true).present? &&
    user && user == record && record.friends_reqs.where(request: true).present?
  end

end
