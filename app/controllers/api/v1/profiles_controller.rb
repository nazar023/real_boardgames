# frozen_string_literal: true

module Api
  module V1
    class ProfilesController < BaseController # :nodoc:
      def show
        profile = User.find(params[:id])
        friends = profile.friends.each do |friend|
                    friend.sender_id == profile.id ? friend.receiver : friend.sender
                  end
        render json: profile, include: :friends
      end
    end
  end
end
