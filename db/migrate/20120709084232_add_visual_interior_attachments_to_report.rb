class AddVisualInteriorAttachmentsToReport < ActiveRecord::Migration
  def change
    add_column :reports, :visual_interior, :text
  end
end
