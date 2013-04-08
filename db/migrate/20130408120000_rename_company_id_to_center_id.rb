class RenameCompanyIdToCenterId < ActiveRecord::Migration
  def change
    rename_column :reports, :company_id, :center_id
  end

end
