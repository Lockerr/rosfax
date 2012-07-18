class AddWindowsToCars < ActiveRecord::Migration
  def change
    add_column :reports, :windows, :text
  end
end
