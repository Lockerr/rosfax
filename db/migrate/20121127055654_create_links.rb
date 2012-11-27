class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.text :url
      t.integer :report_id
      t.string :site

      t.timestamps
    end
  end
end
