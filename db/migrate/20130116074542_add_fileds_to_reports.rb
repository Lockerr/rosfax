class AddFiledsToReports < ActiveRecord::Migration
  def change
    add_column :reports, :engine_type, :string
    add_column :reports, :transmission, :string
    add_column :reports, :year, :integer
    add_column :reports, :price, :integer
    add_column :reports, :brand_id, :integer
  end
end
