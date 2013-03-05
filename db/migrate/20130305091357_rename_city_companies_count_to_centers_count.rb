class RenameCityCompaniesCountToCentersCount < ActiveRecord::Migration
  def change
    rename_column :cities, :companies_count, :centers_count
  end
end
