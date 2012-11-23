class AddDescriptionToPoints < ActiveRecord::Migration
  def change
    add_column :points, :descriptions, :string
  end
end
