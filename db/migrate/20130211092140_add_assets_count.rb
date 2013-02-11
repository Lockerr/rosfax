class AddAssetsCount < ActiveRecord::Migration
  def change
    add_column :reports, :assets_count, :integer, default: 0, null: false

    Report.reset_column_information
    Report.find_each do |report|
      report.update_attributes assets_count: report.assets.length
    end
  end
end
