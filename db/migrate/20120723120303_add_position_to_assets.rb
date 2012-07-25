class AddPositionToAssets < ActiveRecord::Migration
  def change
    add_column :assets, :position, :string
  end
end
