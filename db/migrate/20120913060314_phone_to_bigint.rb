class PhoneToBigint < ActiveRecord::Migration
  def up
  	change_column :profiles, :phone, :bigint
  end

  def down
  end
end
