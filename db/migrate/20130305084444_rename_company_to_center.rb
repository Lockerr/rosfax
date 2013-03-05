class RenameCompanyToCenter < ActiveRecord::Migration
  def up
    rename_table :companies, :centers
  end

  def down
    rename_table :centers, :companies
  end
end
