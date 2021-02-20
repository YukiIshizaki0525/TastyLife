Rails.application.configure do
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

  config.active_storage.service = :local

  
  ActionMailer::Base.delivery_method = :letter_opener
  
  if Rails.application.credentials.gmail.present?
    mail_address = Rails.application.credentials.gmail[:address]
    password = Rails.application.credentials.gmail[:password]
  else
    mail_address = 'admin@example.com'
    password = 'password'
  end
  
  config.action_mailer.default_url_options =  { host: 'localhost', port: 3000 }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
      address: "smtp.gmail.com",
      port: 587,
      user_name: mail_address,
      password: password,
      authentication: :plain,
      enable_starttls_auto: true
  }

  # メールの送信に失敗した時にエラーを発火させるか (デフォルト値: false)
  config.action_mailer.raise_delivery_errors = true;

  config.action_mailer.perform_caching = false

  config.active_support.deprecation = :log

  config.active_record.migration_error = :page_load

  config.assets.debug = true

  config.assets.quiet = true

  config.file_watcher = ActiveSupport::EventedFileUpdateChecker
end
