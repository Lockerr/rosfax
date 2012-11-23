class AddDescriptionToPoints < ActiveRecord::Migration
  def change
    add_column :points, :description, :string
  end
end
