class AddFieldsToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :address, :string
    add_column :companies, :phone, :bigint
    add_column :companies, :site, :string
  end
end
