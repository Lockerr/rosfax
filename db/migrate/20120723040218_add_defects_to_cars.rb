class AddDefectsToCars < ActiveRecord::Migration
  def change
    add_column :reports, :defects, :text
  end
end
