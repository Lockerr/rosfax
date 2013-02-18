class AddDriveToReports < ActiveRecord::Migration
  def change
    add_column :reports, :drive, :string
  end
end
