class AddCountryIdToReport < ActiveRecord::Migration
  def change
    add_column :reports, :country_id, :integer
  end
end
