# frozen_string_literal: true

module Api
  module V1
    class ApplicationController < ::ApplicationController
      include ActionController::HttpAuthentication::Token::ControllerMethods
      include Authentication

      before_action :set_locale

      rescue_from ActiveRecord::RecordNotFound,        with: :render_not_found
      rescue_from ActiveRecord::RecordInvalid,         with: :render_record_invalid
      rescue_from ActionController::ParameterMissing,  with: :render_parameter_missing
      rescue_from ActionController::BadRequest,        with: :render_bad_request

      private

      def set_locale
        I18n.locale = extract_locale_from_header || I18n.default_locale
      end

      def extract_locale_from_header
        locale = request.headers["Accept-Language"]&.scan(/^[a-z]{2}/)&.first
        return locale if I18n.available_locales.include?(locale&.to_sym)

        I18n.default_locale
      end

      def render_not_found(exception)
        Rails.logger.info { exception }
        render json: { errors: [ I18n.t("errors.not_found") ] }, status: :not_found
      end

      def render_record_invalid(exception)
        Rails.logger.info { exception }
        render json: { errors: exception.record.errors.full_messages }, status: :bad_request
      end

      def render_parameter_missing(exception)
        Rails.logger.info { exception }
        render json: { errors: [ I18n.t("errors.required_parameter_missing") ] }, status: :unprocessable_entity
      end

      def render_bad_request(exception)
        Rails.logger.info { exception }
        render json: { errors: [ exception.message ] }, status: :bad_request
      end
    end
  end
end
