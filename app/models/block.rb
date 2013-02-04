class Block < ActiveRecord::Base
  attr_accessible :company_id, :day, :hour, :month

  belongs_to :company
end
