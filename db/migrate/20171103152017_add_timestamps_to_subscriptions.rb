class AddTimestampsToSubscriptions < ActiveRecord::Migration[5.0]
  def change
    add_column :subscriptions, :created_at, :datetime, null: false, :default => DateTime.now
    add_column :subscriptions, :updated_at, :datetime, null: false, :default => DateTime.now
  end
end
