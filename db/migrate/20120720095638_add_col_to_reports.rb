class AddColToReports < ActiveRecord::Migration
  def change
    add_column :reports, :under_the_hood, :text
    add_column :reports, :photo_others, :text
  end
end
