class Center < ActiveRecord::Base
  attr_accessible :name, :city, :new_schedule_emails, :change_schedule_emails, :address, :timing, :phone
  has_many :users
  has_many :reports

  has_one :asset, :as => :attachable

  has_many :schedules
  has_many :blocks
  belongs_to :city, counter_cache: true
  serialize :new_schedule_emails, Array
  serialize :change_schedule_emails, Array


  def asset_url
    if asset
      asset.url
    else
      ''
    end
  end

end
