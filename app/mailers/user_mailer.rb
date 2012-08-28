class UserMailer < ActionMailer::Base
  include Devise::Mailers::Helpers

  default from: "do-not-replay@rosfax.ru"

  def confirmation_instructions(record)
    devise_mail(record, :confirmation_instructions)
  end

  def reset_password_instructions(record)
    devise_mail(record, :reset_password_instructions)
  end

end
