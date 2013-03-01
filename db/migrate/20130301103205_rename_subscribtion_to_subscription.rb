class RenameSubscribtionToSubscription < ActiveRecord::Migration
  def up
    rename_table :subscribtions, :subscriptions
  end

  def down
    rename_table :subscriptions, :subscribtions
  end
end
