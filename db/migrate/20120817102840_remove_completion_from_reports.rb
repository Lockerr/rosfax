class RemoveCompletionFromReports < ActiveRecord::Migration
  def up
    remove_column :reports, :completion
  end

  def down
  end
end
