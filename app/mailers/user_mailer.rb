#encoding: utf-8
class UserMailer < ActionMailer::Base
  include Devise::Mailers::Helpers

  default from: "do-not-replay@rosfax.ru"

  def confirmation_instructions(record)
    devise_mail(record, :confirmation_instructions)
  end

  def reset_password_instructions(record)
    devise_mail(record, :reset_password_instructions)
  end

  def new_schedule_notification(record, recepient)
    @schedule = record
    mail(:to => recepient, subject: 'Rosfax: новая запись на осмотр.')
  end

  def change_schedule_notification(record, recepient)
    @schedule = record
    mail(:to => recepient, subject: 'Rosfax: изменение времени осмотра.')
  end


end
