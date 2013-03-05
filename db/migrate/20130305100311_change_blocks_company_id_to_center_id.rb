class ChangeBlocksCompanyIdToCenterId < ActiveRecord::Migration
  def change
    rename_column :blocks, :company_id, :center_id
  end


end
