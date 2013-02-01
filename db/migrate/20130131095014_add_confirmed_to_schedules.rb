class AddConfirmedToSchedules < ActiveRecord::Migration
  def change
    add_column :schedules, :confirmed, :boolean, :default => false
  end
end
