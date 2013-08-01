class AddLastFourDigitsOfCreditCardToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_four_digits_of_credit_card, :integer
  end
end
