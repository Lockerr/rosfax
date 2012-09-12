class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :name
      t.string :org
      t.integer :phone
      t.integer :user_id

      t.timestamps
    end
  end
end
