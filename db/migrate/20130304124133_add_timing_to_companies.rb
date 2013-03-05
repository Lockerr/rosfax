class AddTimingToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :timing, :string
  end
end
