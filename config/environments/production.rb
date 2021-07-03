Rails.application.configure do
  config.cache_classes = true

  config.eager_load = true

  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  config.require_master_key = true
  config.public_file_server.enabled = true

  config.assets.compile = true

  config.log_level = :debug

  config.log_tags = [ :request_id ]

  config.action_mailer.perform_caching = false

  host = Rails.application.credentials.server[:ip]

  config.action_mailer.default_url_options = { host: host}

  config.action_mailer.perform_deliveries = true

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address:"smtp.gmail.com",
    domain: 'gmail.com',
    port:587,
    user_name: ENV['SEND_MAIL'],
    password: ENV['GMAIL_SPECIFIC_PASSWORD'],
    authentication: :login,
    openssl_verify_mode: 'none',
    enable_starttls_auto: true
  }

  config.action_mailer.perform_caching = false

  config.action_mailer.raise_delivery_errors = true

  config.i18n.fallbacks = [I18n.default_locale]

  config.active_support.deprecation = :notify

  config.log_formatter = ::Logger::Formatter.new

  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end

  config.active_record.dump_schema_after_migration = false
end
