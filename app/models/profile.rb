class Profile < ActiveRecord::Base
  attr_accessible :name, :org, :phone, :user_id

  belongs_to :user

  def company_name
    user.company_name
  end

  def timing
    user.company.timing
  end

  def timing=(range)
    user.company.update_attributes :timing, range
  end

  def address
    user.company.address
  end

  def address=(address)
    user.company.address = address
  end
end
