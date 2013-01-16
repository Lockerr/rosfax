class CreateSubscribtions < ActiveRecord::Migration
  def change
    create_table :subscribtions do |t|
      t.integer :user_id
      t.text :filter
      t.boolean :by_email
      t.integer :email_period

      t.timestamps
    end
  end
end
