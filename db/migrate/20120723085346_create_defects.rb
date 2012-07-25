class CreateDefects < ActiveRecord::Migration
  def change
    create_table :defects do |t|

      t.timestamps
    end
  end
end
