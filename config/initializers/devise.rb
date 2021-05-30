Devise.setup do |config|
  # config.mailer = 'Devise::Mailer'
  config.mailer = 'Users::Mailer'

  config.mailer_sender = '認証メール<noreply@example.com>'

  require 'devise/orm/active_record'

  # usernameとemailで認証可能(デフォルトはemailのみ)
  config.authentication_keys = [:email]

  config.case_insensitive_keys = [:email]

  config.strip_whitespace_keys = [:email]

  config.skip_session_storage = [:http_auth]

  config.stretches = Rails.env.test? ? 1 : 12

  config.reconfirmable = true

  config.expire_all_remember_me_on_sign_out = true

  config.password_length = 6..20

  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/

  config.timeout_in = 1.day

  # 認証メールの有効期限を24時間以内に設定
  config.confirm_within = 1.days

  config.reset_password_within = 6.hours

  config.scoped_views = true

  config.sign_out_via = :delete

  config.confirm_within = 1.days

end
