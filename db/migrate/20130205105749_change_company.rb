class ChangeCompany < ActiveRecord::Migration
  def change
    add_column :companies, :new_schedule_emails, :text
    add_column :companies, :change_schedule_emails, :text
  end
end
