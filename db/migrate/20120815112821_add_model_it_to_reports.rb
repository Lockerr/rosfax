class AddModelItToReports < ActiveRecord::Migration
  def change
    add_column :reports, :model_id, :integer
  end
end
