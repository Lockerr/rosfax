#encoding: utf-8
class Schedule < ActiveRecord::Base
  attr_accessible :company_id, :inspection_start_date, :inspection_start_time, :name, :phone, :hour, :confirmed, :time, :date
  belongs_to :company
  # validate :scheduling

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
