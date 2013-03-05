class ChangeUserCompanyIdToCenterId < ActiveRecord::Migration
  def change
    rename_column :users, :company_id, :center_id
  end


end
