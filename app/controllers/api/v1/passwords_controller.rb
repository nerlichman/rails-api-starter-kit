# frozen_string_literal: true

module Api
  module V1
    class PasswordsController < ApplicationController
      allow_unauthenticated_access only: %i[ create ]
      before_action :set_user_by_token, only: %i[ update ]
      # rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_password_path, alert: "Try again later." }

      def create
        if user = User.find_by(email: params[:email])
          PasswordsMailer.reset(user).deliver_later
        end

        render json: { message: "Password reset instructions sent" }
      end

      def update
        if @user.update(params.permit(:password, :password_confirmation))
          @user.sessions.destroy_all
          render json: { message: "Password has been reset." }
        else
          render json: { errors: @user.errors.full_messages }, status: :unprocessable_content
        end
      end

      private

      def set_user_by_token
        @user = User.find_by_password_reset_token!(params[:token])
      rescue ActiveSupport::MessageVerifier::InvalidSignature
        render json: { errors: [ "Password reset link is invalid or has expired." ] }, status: :unauthorized
      end
    end
  end
end
