class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :user_id
      t.integer :bill_amount

      t.timestamps
    end
  end
end
