class Profile < ActiveRecord::Base
  attr_accessible :name, :org, :phone, :user_id

  belongs_to :user
end
