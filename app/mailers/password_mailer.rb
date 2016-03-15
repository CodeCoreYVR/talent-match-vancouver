class PasswordMailer < ApplicationMailer
  default from: "admin@talentmatch.com"

  def password_reset(user)
    @user = user
    mail(to: @user.email, subject: "Link to reset your password")
  end
end
