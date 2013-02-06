class Company < ActiveRecord::Base
  attr_accessible :name, :city, :new_schedule_emails, :change_schedule_emails
  has_many :users
  has_many :reports

  has_one :asset, :as => :attachable

  has_many :schedules
  has_many :blocks

  serialize :new_schedule_emails, Array
  serialize :change_schedule_emails, Array

end
