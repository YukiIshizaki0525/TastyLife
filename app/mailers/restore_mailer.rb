class RestoreMailer < ApplicationMailer
  def send_when_restore(email)
    @user = User.find_by(email: email)
    mail to: email, subject: 'アカウント復旧手続き'
  end
end
