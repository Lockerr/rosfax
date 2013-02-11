class AddKeyToReports < ActiveRecord::Migration
  def change
    add_column :reports, :access_key, :integer
    for r in Report.all
      r.update_attributes access_key: rand(100000..1000000-1)
    end
  end
end
