class Company < ActiveRecord::Base
  attr_accessible :name
  has_many :users
  has_many :reports

  has_one :asset, :as => :attachable
end
