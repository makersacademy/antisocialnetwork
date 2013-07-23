class RenameCustomerIdColumn < ActiveRecord::Migration
  def change
    rename_column :users, :customer_id, :stripe_customer_id
  end
end
