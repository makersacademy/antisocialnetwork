class Payment < ActiveRecord::Base
  belongs_to :user

  def self.calculate_amount(activity=100)
    activity
  end

  def self.make_payment(amount, user)
    Stripe::Charge.create(:amount => amount, 
                          :currency => "GBP", 
                          :description => "Weekly payment", 
                          :customer => user.stripe_customer_id)
    Payment.create(:user_id => user.id, :bill_amount => amount)
  end

  def self.charge_all_user
    users = User.all
    users.each do |user|
      self.make_payment(self.calculate_amount, user)
    end 
  end   
end
