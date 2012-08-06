class Model < ActiveRecord::Base
  validates_presence_of :category

  belongs_to :brand
end
