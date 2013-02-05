class Company < ActiveRecord::Base
  attr_accessible :name, :city
  has_many :users
  has_many :reports

  has_one :asset, :as => :attachable

  has_many :schedules
  has_many :blocks

end
