require 'spec_helper'

describe Payment do  

  before do 
    @user = FactoryGirl.create(:user)
    activity1 = FactoryGirl.create(:activity, user_id: @user.id)
    activity2 = FactoryGirl.create(:activity, user_id: @user.id, 
                                              created_at: DateTime.now - 4.days) 
  end  

  describe "charging a single user" do
    it "should only calculate the number of activities in the past seven days" do
      activity2 = FactoryGirl.create(:activity, user_id: @user.id, 
                                                created_at: DateTime.now - 8.days) 
      expect(Payment.calculate_activity(@user)).to eq(1)
    end  

    it "should calculate the cost of the past weeks activities" do
      activities = Payment.calculate_activity(@user)
      expect(Payment.calculate_amount(activities)).to eq(50)
    end

    it "should add the bill amount to users billing history" do
      stub_stripe
      Payment.make_payment(100, @user)
      expect(@user.payments.first.bill_amount).to eq(100)
    end
  end

  describe "charging all users" do
    it "should only charge users with a stripe customer id" do
      user2 = FactoryGirl.create(:user, stripe_customer_id: "nil")
      stub_stripe
      Payment.charge_all_users
      expect(@user.payments.first.bill_amount).to eq(50)
      expect(Payment.count).to eq(1)
    end
  end

end
