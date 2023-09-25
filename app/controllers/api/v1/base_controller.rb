# frozen_string_literal: true

module Api
  module V1
    class BaseController < ActionController::Base # :nodoc:
      before_action :authenticate_token

      attr_reader :current_user, :current_api_token

      def authenticate_token
        authenticate_user_token || handle_bad_authentication
      end

      private

      def authenticate_user_token
        authenticate_with_http_token do |token, options|
          @current_api_token = ApiToken.where(status: "active").find_by(token: token)
          @current_user = @current_api_token&.user
        end
      end

      def handle_bad_authentication
        render json: { message: "Not valid token authentication" }, status: :unauthorized
      end
    end
  end
end
