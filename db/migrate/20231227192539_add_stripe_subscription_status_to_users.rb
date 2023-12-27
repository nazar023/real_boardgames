class AddStripeSubscriptionStatusToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :subscription_status, :string
    add_column :users, :subscription_type, :integer, default: 0
    add_column :users, :subscription_ends_at, :datetime
  end
end
