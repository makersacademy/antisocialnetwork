class Payment < ActiveRecord::Base
  belongs_to :user

  def calculate_amount(activity)
  end

  def self.make_payment(amount, user)
    Stripe::Charge.create(:amount => amount, 
                          :currency => "GBP", 
                          :description => "Weekly payment", 
                          :customer => user.stripe_customer_id)
    Payment.create(:user_id => user.id, :bill_amount => amount)
  end

  def gpayment_from_all_user
    users = User.all
    users.each do |user|
      make_payment(calculate_amount(x), user)
    end 
  end   
end
