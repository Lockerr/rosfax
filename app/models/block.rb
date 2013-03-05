class Block < ActiveRecord::Base
  attr_accessible :company_id, :date, :hour

  belongs_to :center
end
