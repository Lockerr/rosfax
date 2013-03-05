class ChangeCompanyToCenterId < ActiveRecord::Migration
  def change
    rename_column :schedules, :company_id, :center_id
  end
end
