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

  def new_schedule_notification(record)
    @schedule = record
    for email in @schedule.company.new_schedule_emails
      mail(:to => email, subject: 'мргл-мргл ом-ном-ном') if email.presence
    end
  end

  def change_schedule_notification(record)
    @schedule = record
    for email in @schedule.company.change_schedule_emails
      mail(:to => email, subject: 'УПЯЧКА! УПЯЧКА! УБЕЙТЕ МЕНЯ КТОНИБУДЬ!!!') if email.presence
    end
  end


end
