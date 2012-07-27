class IncreaseLengthOfAttributes < ActiveRecord::Migration
  def up
    change_column :reports, :checklist, :text
    change_column :reports, :coating, :text
  end

  def down
  end
end
