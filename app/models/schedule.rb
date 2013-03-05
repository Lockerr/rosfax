#encoding: utf-8
class Schedule < ActiveRecord::Base
  attr_accessible :center_id, :inspection_start_date, :inspection_start_time, :name, :phone, :hour, :confirmed, :time, :date

  belongs_to :center

  validates_presence_of :center_id

  def notify_about_creation
    for email in center.new_schedule_emails.delete_if{|e| e.empty?}
      UserMailer.delay.new_schedule_notification(self, email)
    end 
  end

  def notify_about_moving
    for email in center.new_schedule_emails.delete_if{|e| e.empty?}
      UserMailer.delay.change_schedule_notification(self, email)
    end
  end

  def start_time
    inspection_start_time
  end



  def match(day, hour)
    return false unless inspection_start_time.to_date == Date.today + day.days
    return false unless inspection_start_time.hour == hour
    true
  end

  private

  def scheduling
   true # errors.add(:base, "На #{inspection_start_time} в #{I18n.localize(Schedule.where(:inspection_start_time => inspection_start_time.localtime).last.created_at)} уже назначен осмотр") if Schedule.where(:inspection_start_time => inspection_start_time).any?
  end

end
