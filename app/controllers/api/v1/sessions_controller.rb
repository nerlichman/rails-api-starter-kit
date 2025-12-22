# frozen_string_literal: true

module Api
  module V1
    class SessionsController < ApplicationController
      allow_unauthenticated_access only: [ :create ]
      # rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_path, alert: "Try again later." }

      def create
        if user = User.authenticate_by(session_params)
          start_new_session_for(user)
          render json: { token: Current.session.token, user: UserResource.new(user) }
        else
          render json: { errors: [ "Invalid email or password" ] }, status: :unauthorized
        end
      end

      def destroy
        terminate_session
        render json: { message: "Logged out" }, status: :ok
      end

      private

      def session_params
        params.permit(:email, :password)
      end
    end
  end
end
