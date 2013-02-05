class ChangeBlock < ActiveRecord::Migration
  def change
    add_column :blocks, :date, :date
    remove_column :blocks, :day
    remove_column :blocks, :month
  end
end
