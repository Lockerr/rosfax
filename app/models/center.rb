class Center < ActiveRecord::Base
  attr_accessible :name, :city, :new_schedule_emails, :change_schedule_emails, :address, :timing, :phone, :timing_to, :timing_from, :telephone
  has_many :users
  has_many :reports

  has_one :asset, :as => :attachable

  has_many :schedules
  has_many :blocks
  belongs_to :city, counter_cache: true
  serialize :new_schedule_emails, Array
  serialize :change_schedule_emails, Array
  serialize :timing, Hash

  def asset_url
    if asset
      asset.url
    else
      ''
    end
  end

  def telephone=(string)
    self.phone = string.scan(/\d+/).join[1..-1]
  end

  def telephone
    phone
  end

  def timing_from=(hour)
    timing['from'] = hour
  end

  def timing_from
    timing['from']
  end

  def timing_to
    timing['to']
  end

  def timing_to=(hour)
    timing['to'] = hour
  end
end
