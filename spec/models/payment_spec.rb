require 'spec_helper'

describe Payment do  

  describe "charging the user" do 
    it "should add bill amount to users billing history" do
      user = FactoryGirl.create(:user) 
      stub_stripe
      Payment.make_payment(100, user)
      expect(user.payments.first.bill_amount).to eq(100)
    end
  end  
end
