class AddProcessingToAssets < ActiveRecord::Migration
  def change
    add_column :assets, :data_processing, :boolean
  end
end
