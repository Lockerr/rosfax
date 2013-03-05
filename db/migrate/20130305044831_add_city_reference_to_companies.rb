class AddCityReferenceToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :city_id, :integer

    Center.find_each do |company|
      company.city_id = City.find_or_create_by_name company.city
    end

    remove_column :companies, :city

  end
end
