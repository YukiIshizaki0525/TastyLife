class Users::Mailer < Devise::Mailer
  helper :application
  include Devise::Controllers::UrlHelpers
  default template_path: 'devise/mailer'
  
  def confirmation_instructions(record, token, opts={})
    mail = super
    mail.subject = "認証を行ってユーザ登録を完了してください"
    mail
  end
end