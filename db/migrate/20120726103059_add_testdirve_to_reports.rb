class AddTestdirveToReports < ActiveRecord::Migration
  def change
  	add_column :reports, :testdrive, :text
  end
end
