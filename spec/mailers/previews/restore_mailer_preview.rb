# Preview all emails at http://localhost:3000/rails/mailers/restore_mailer
class RestoreMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/restore_mailer/send_when_restore
  def send_when_restore
    RestoreMailer.send_when_restore
  end

end
