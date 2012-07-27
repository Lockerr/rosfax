class AddChecklistToReports < ActiveRecord::Migration
  def change
  	add_column :reports, :checklist, :string
  end
end
