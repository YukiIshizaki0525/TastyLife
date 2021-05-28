class RestoreMailer < ApplicationMailer
  
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.restore_mailer.send_when_restore.subject
  #
  def send_when_restore(email)
    @user = User.find_by(email: email)
    mail to: email, subject: 'アカウント復旧手続き'
  end
end
