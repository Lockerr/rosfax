class Clear < ActiveRecord::Migration
  def up
  	remove_column :reports, :visual_interior
  	remove_column :reports, :windows_lights
  	remove_column :reports, :exterior_parts
  	remove_column :reports, :powertrains
  	remove_column :reports, :electric_parts
  	remove_column :reports, :liquid_levels
  	remove_column :reports, :chasis
  	remove_column :reports, :testdrive
  	remove_column :reports, :windows
  	remove_column :reports, :dumpers
  	remove_column :reports, :brakes
  	remove_column :reports, :defects
  	remove_column :reports, :coating
  end

  def down
  end
end
