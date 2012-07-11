class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.integer :car_id

      t.timestamps
    end
  end
end
