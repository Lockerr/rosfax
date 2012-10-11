class AddFieldsToAssets < ActiveRecord::Migration
  def change
  	add_column :assets, :section, :string
  	add_column :assets, :place, :string
  end
end
