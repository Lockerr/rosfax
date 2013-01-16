class RewriteFieldsForReport < ActiveRecord::Migration
  def up
    Report.find_each do |report|
      report.engine_type = report.car[:engine_type] if report.car
      report.transmission = report.car[:transmission] if report.car
      report.year = report.car[:year] if report.car['car']
      report.price = report.car[:price] if report.car
      report.brand_id = report.model.brand_id
      report.save
    end
  end

  def down
  end
end
