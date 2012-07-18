class AddFieldsToReport < ActiveRecord::Migration
  def change
    add_column :reports, :exterior, :text
    add_column :reports, :windows_lights, :text
    add_column :reports, :exterior_parts, :text
    add_column :reports, :powertrains, :text
    add_column :reports, :electric_parts, :text
    add_column :reports, :liquid_levels, :text
    add_column :reports, :chasis, :text
    add_column :reports, :completion, :text
    add_column :reports, :testdrtive, :text
  end
end
