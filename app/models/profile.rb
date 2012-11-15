class Profile < ActiveRecord::Base
  attr_accessible :name, :org, :phone, :user_id

  belongs_to :user

  def company_name
    user.company_name
  end
end
