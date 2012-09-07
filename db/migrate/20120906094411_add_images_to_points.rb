class AddImagesToPoints < ActiveRecord::Migration
  def change
    add_column :points, :images, :string
  end
end
