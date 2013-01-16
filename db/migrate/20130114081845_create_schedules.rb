class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.integer :company_id
      t.datetime :inspection_start_time
      t.string :name
      t.string :phone

      t.timestamps
    end
  end
end
