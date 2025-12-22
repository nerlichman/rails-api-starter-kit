# frozen_string_literal: true

module Api
  module V1
    class RegistrationsController < ApplicationController
      allow_unauthenticated_access only: %i[ create ]

      def create
        user = User.new(user_params)
        if user.save
          start_new_session_for(user)
          render json: { token: Current.session.token, user: UserResource.new(user) }, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      rescue ActiveRecord::RecordNotUnique
        render json: { errors: [ "There was a problem creating your account" ] }, status: :unprocessable_entity
      end

      private

      def user_params
        params.permit(:email, :password, :password_confirmation, :name)
      end
    end
  end
end
