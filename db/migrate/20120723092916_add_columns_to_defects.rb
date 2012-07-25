class AddColumnsToDefects < ActiveRecord::Migration
  def change
    add_column :defects, :category, :string
    add_column :defects, :sub_category, :string
    add_column :defects, :defect_type, :string
    add_column :defects, :size, :string
  end
end
