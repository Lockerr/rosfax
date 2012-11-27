class AddLinksToCar < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.text :url
      t.references :report
    end
  end
end
