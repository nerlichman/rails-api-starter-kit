# frozen_string_literal: true

Sentry.init do |config|
  config.breadcrumbs_logger = [ :active_support_logger, :http_logger, :sentry_logger ]
  config.dsn = ENV["SENTRY_DSN"]

  # Patch Ruby logger to forward logs
  config.enabled_patches = [ :logger ]
end

Sentry.configure_scope do |scope|
  scope.set_tag(:service, "backend")
end
