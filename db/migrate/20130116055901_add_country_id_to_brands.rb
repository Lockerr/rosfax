class AddCountryIdToBrands < ActiveRecord::Migration
  def change
    add_column :brands, :country_id, :integer
  end
end
