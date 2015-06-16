require 'pusher'
Deploy::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  config.project_checkout_path = Rails.root.join('..', 'deploy_projects')

  Pusher.app_id = 87380
  Pusher.key = 'ad3b3ac62e18e65df34b'
  Pusher.secret = 'c108dd2a9e203074bd77'
  Pusher.host = 'localhost'
  Pusher.port = 8080
  Slim::Engine.options[:pretty] = false
end


