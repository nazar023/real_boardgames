# frozen_string_literal: true

module Api
  module V1
    class ProfilesController < BaseController # :nodoc:
      def show
        user_profile = User.find(params[:id])
        friends = user_profile.friendships_users
        render json: {User: user_profile, Friends: friends}
      end
    end
  end
end
