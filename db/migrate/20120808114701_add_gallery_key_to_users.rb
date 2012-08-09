class AddGalleryKeyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :gallery_key, :string
  end
end
