class RefactorSchedule < ActiveRecord::Migration
  def change
    add_column :schedules, :date, :date
    add_column :schedules, :hour, :integer
  end
end
