class CreateBlocks < ActiveRecord::Migration
  def change
    create_table :blocks do |t|
      t.integer :month
      t.integer :day
      t.integer :hour
      t.integer :company_id

      t.timestamps
    end
  end
end
