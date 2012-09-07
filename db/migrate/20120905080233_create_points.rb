class CreatePoints < ActiveRecord::Migration
  def change
    create_table :points do |t|
      t.string :object
      t.integer :report_id
      t.string :section
      t.string :place
      t.string :condition
      t.string :state

      t.timestamps
    end
  end
end
