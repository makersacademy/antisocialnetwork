require 'spec_helper'

describe Payment do  

  describe "charging a single user" do 
    it "should add bill amount to users billing history" do
      user = FactoryGirl.create(:user) 
      stub_stripe
      Payment.make_payment(100, user)
      expect(user.payments.first.bill_amount).to eq(100)
    end
  end  

  describe "charging all users" do
    it "should only charge user with stripe customer id" do
      user1 = FactoryGirl.create(:user, name:"Tom", email: "t@gmail.com", 
                                        stripe_customer_id: "scid 453443")
      user2 = FactoryGirl.create(:user)
      stub_stripe
      Payment.charge_all_users
      expect(user1.payments.first.bill_amount).to eq(1000)
      expect(Payment.count).to eq(1)
    end
  end


end
