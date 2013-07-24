class Payment < ActiveRecord::Base
  belongs_to :user

  def self.calulate_activity(user)

  end  

  def self.calculate_amount(activity=100)
    activity * 10
  end

  def self.create_bill_amount(user_id, amount)
    Payment.create(:user_id => user_id, :bill_amount => amount)
  end  

  def self.make_payment(amount, user)
    Stripe::Charge.create(:amount => amount, 
                          :currency => "GBP", 
                          :description => "Weekly payment", 
                          :customer => user.stripe_customer_id)
    self.create_bill_amount(user.id, amount)  
  end

  def self.charge_all_users
    users = User.where.not(stripe_customer_id: 'nil')
    users.each do |user|
      self.make_payment(self.calculate_amount, user)
    end 
  end   
end
