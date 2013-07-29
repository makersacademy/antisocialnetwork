class AddCharityToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :charity, :string
  end
end
