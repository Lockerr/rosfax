class AddIndexReportIdToPoints < ActiveRecord::Migration
  def change
  	add_index :points, :report_id
  end
end
