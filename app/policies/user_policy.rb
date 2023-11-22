# frozen_string_literal: true

class UserPolicy < ApplicationPolicy # :nodoc:

  def friends?
    user &&
      user != record &&
      record.friendships.find_by(sender_id: record.id, receiver_id: user.id).blank? &&
      record.friendships.find_by(sender_id: user.id, receiver_id: record.id).blank? &&
      record.friendships_reqs.find_by(receiver_id: record.id, sender_id: user.id).blank?
  end

  def edit?
    user?
  end

  def update?
    edit?
  end

  def destroy?
    edit?
  end

  def user?
    profile_owner
  end

  def has_requests?
    profile_owner && record.friendships_reqs.present?
  end

  def has_notifications?
    profile_owner && record.notifications.present?
  end


  private

  def profile_owner
    user && user == record
  end
end
