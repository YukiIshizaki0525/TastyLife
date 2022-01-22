Rails.application.configure do
  config.after_initialize do
    Bullet.enable        = true
    Bullet.alert         = true
    Bullet.bullet_logger = true
    Bullet.console       = true
  # Bullet.growl         = true
    Bullet.rails_logger  = true
    Bullet.add_footer    = true
  end

  config.cache_classes = false
  config.eager_load = false
  config.consider_all_requests_local = true

  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.seconds.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end
  # config.active_storage.service = :local
  ActionMailer::Base.delivery_method = :letter_opener
  
  config.action_mailer.default_url_options = {  host: 'localhost', port: 3000 }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address:"smtp.gmail.com",
    domain: 'gmail.com',
    port:587,
    user_name: Rails.application.credentials.gmail[:user_name],
    password: Rails.application.credentials.gmail[:password],
    authentication: :login
  }

  config.action_mailer.raise_delivery_errors = false;
  config.action_mailer.perform_caching = false
  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load
  config.assets.debug = true
  config.assets.quiet = true

  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  config.webpacker.check_yarn_integrity = false
end
