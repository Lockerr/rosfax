class AddInteriorToReport < ActiveRecord::Migration
  def change
    add_column :reports, :interior, :text
  end
end
