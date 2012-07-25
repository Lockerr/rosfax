class AddImagesToDefects < ActiveRecord::Migration
  def change
    add_column :defects, :images, :string
  end
end
