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
  
  #deviseが認証用のURLなどを生成するのに必要になる（らしい）
  config.action_mailer.default_url_options = {  host: 'localhost', port: 3000 }
  #送信方法を指定（この他に:sendmail/:file/:testなどがあります)
  config.action_mailer.delivery_method = :smtp
  #送信方法として:smtpを指定した場合は、このconfigを使って送信詳細の設定を行います
  config.action_mailer.smtp_settings = {
    #gmail利用時はaddress,domain,portは下記で固定
    address:"smtp.gmail.com",
    domain: 'gmail.com',
    port:587,
    #gmailのユーザアカウント（xxxx@gmail.com)※念のため、credentials.yml.enc行き
    user_name: Rails.application.credentials.gmail[:user_name],
    #gmail２段階認証回避のためにアプリケーションでの利用パスワードを取得、必ずcredentials.yml.endに設定を！！
    password: Rails.application.credentials.gmail[:password],
    #パスワードをBase64でエンコード
    authentication: :login
  }

  # メールの送信に失敗した時にエラーを発火させるか (デフォルト値: false)
  config.action_mailer.raise_delivery_errors = false;

  config.action_mailer.perform_caching = false

  config.active_support.deprecation = :log

  config.active_record.migration_error = :page_load

  config.assets.debug = true

  config.assets.quiet = true

  config.file_watcher = ActiveSupport::EventedFileUpdateChecker
end
