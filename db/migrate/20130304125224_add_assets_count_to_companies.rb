class AddAssetsCountToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :assets_count, :integer
  end
end
