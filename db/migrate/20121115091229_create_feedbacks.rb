class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.text :text
      t.string :author

      t.timestamps
    end
  end
end
