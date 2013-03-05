class Profile < ActiveRecord::Base
  attr_accessible :name, :org, :phone, :user_id, :address, :timing

  belongs_to :user

  def company_name
    user.company_name
  end

  def timing
    user.center.timing
  end


  def phone=(phone)
    user.center.update_attributes phone: phone
  end

  def timing=(range)
    user.center.update_attributes timing: range
  end

  def address
    user.center.address
  end

  def address=(address)
    user.center.update_attributes address: address
  end
end
