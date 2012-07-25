class AddWheelsToReports < ActiveRecord::Migration
  def change
    add_column :reports, :wheels, :text
  end
end
