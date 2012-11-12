class AddTestdrivestatusdescriptionToReports < ActiveRecord::Migration
  def change
    add_column :reports, :testdrive_description, :text
  end
end
