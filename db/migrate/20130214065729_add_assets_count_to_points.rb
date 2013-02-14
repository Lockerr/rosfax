class AddAssetsCountToPoints < ActiveRecord::Migration
  def change
    add_column :points, :assets_count, :integer, default: 0, null: false

    Point.reset_column_information
    Point.find_each do |point|
      point.update_attributes assets_count: point.assets.length
    end
  end
end
