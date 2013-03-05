class City < ActiveRecord::Base
  attr_accessible :cities_count, :integer, :name
  has_many :centers
end
