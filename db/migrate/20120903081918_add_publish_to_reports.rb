class AddPublishToReports < ActiveRecord::Migration
  def change
    add_column :reports, :publish, :boolean, :default => false
  end
end
