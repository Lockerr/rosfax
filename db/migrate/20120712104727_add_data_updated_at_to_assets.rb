class AddDataUpdatedAtToAssets < ActiveRecord::Migration
  def change
    add_column :assets, :data_updated_at, :datetime
  end
end
