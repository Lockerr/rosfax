class AddCoatingToReports < ActiveRecord::Migration
  def change
    add_column :reports, :coating, :string
  end
end
