class AddReportIdToDefects < ActiveRecord::Migration
  def change
    add_column :defects, :report_id, :integer
  end
end
