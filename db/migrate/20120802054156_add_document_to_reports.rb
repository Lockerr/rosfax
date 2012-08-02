class AddDocumentToReports < ActiveRecord::Migration
  def change
    add_column :reports, :documents, :text
  end
end
