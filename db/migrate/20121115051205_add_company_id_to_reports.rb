class AddCompanyIdToReports < ActiveRecord::Migration
  def change
    add_column :reports, :company_id, :integer
  end
end
