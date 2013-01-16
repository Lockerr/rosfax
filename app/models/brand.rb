class Brand < ActiveRecord::Base
  has_many :models
  has_many :reports

  belongs_to :country
end
