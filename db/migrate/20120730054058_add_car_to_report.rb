class AddCarToReport < ActiveRecord::Migration
  def change
    add_column :reports, :car, :text
  end
end
