class Country < ActiveRecord::Base
  attr_accessible :name

  has_many :brands
  has_many :reports
end
