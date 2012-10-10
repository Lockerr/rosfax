class RemoveChecklistsAndTestdriveFromReports < ActiveRecord::Migration
  def up
  	# remove_column :reports, :checklist
  	remove_column :reports, :testdrtive
  end
end
