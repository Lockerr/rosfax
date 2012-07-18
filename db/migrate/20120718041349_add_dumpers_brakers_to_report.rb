class AddDumpersBrakersToReport < ActiveRecord::Migration
  def change
    add_column :reports, :dumpers, :text
    add_column :reports, :brakes, :text
  end
end
