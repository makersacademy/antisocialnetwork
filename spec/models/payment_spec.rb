require 'spec_helper'

describe Payment do  

  let(:charity){FactoryGirl.create(:charity)}
  let(:the_user){FactoryGirl.create(:user, charity_id: charity.id)}
  
  before(:each) do
    activity1 = FactoryGirl.create(:activity, user_id: the_user.id, 
                                              activity_updated_time: 4.days.ago)
  end

  describe "METHOD users_current_payment_period" do
    context "when a new user hasn't made a payment" do
      it "returns the period since joining" do
        joined_date = 2.day.ago
        the_user.stub(:created_at).and_return(joined_date)
        Time.stub(:now).and_return(Date.today)
        expected_date_range = joined_date..Time.now
        Payment.users_current_payment_period(the_user).should == expected_date_range
      end
    end

    context "when a user has made a payment" do
      it "returns the period since the last payment" do
        date_of_last_payment = 3.day.ago
        the_user.stub_chain("payments.last.created_at").and_return(date_of_last_payment)
        the_user.stub_chain("payments.length").and_return(1)
        Time.stub(:now).and_return(Date.today)
        expected_date_range = date_of_last_payment..Time.now
        Payment.users_current_payment_period(the_user).should == expected_date_range
      end
    end
  end

  describe "charging a single user" do
    context "when a user has NO previous payments" do

      before(:each) do
        joined_date = 5.day.ago
        the_user.stub(:created_at).and_return(joined_date)
      end

      it "should only calculate the number of activities since the user joined" do
        activity3 = FactoryGirl.create(:activity, user_id: the_user.id, 
                                                  activity_updated_time: 6.days.ago) 
        expect(Payment.calculate_activity(the_user)).to eq(1)
      end  

      it "should calculate the cost of the activities since the user joined" do
        activity3 = FactoryGirl.create(:activity, user_id: the_user.id, 
                                                  activity_updated_time: 6.days.ago) 
        activities = Payment.calculate_activity(the_user)
        expect(Payment.calculate_amount(activities)).to eq(50)
      end

      
    end

    context "when a user has previous payments" do

      before(:each) do
        FactoryGirl.create(:payment, user_id: the_user.id)
        date_of_last_payment = 6.day.ago
        the_user.stub_chain("payments.last.created_at").and_return(date_of_last_payment)
        the_user.stub_chain("payments.length").and_return(1)
      end

      it "should only calculate the number of activities in the past seven days" do
        activity3 = FactoryGirl.create(:activity, user_id: the_user.id, 
                                                  activity_updated_time: 8.days.ago) 
        expect(Payment.calculate_activity(the_user)).to eq(1)
      end  

      it "should calculate the cost of the past weeks activities" do
        activities = Payment.calculate_activity(the_user)
        activity3 = FactoryGirl.create(:activity, user_id: the_user.id, 
                                                  activity_updated_time: 8.days.ago) 
        expect(Payment.calculate_amount(activities)).to eq(50)
      end

    end


    it "should add the bill amount and charity to users billing history" do
      stub_stripe
      Payment.make_payment(100, the_user)
      expect(the_user.payments.first.bill_amount).to eq(100)
      expect(the_user.payments.first.charity).to eq("MyString")
    end

  end

  describe "charging all users" do
    context "when users have NO previous payments" do
      it "should only charge users with a stripe customer id" do
        user2 = FactoryGirl.create(:user, stripe_customer_id: "nil")
        user3 =FactoryGirl.create(:user, charity_id: charity.id, created_at: 5.days.ago)
        user3activity1 = FactoryGirl.create(:activity, user_id: user3.id, 
                                            activity_updated_time: 4.days.ago)
        user3activity2 = FactoryGirl.create(:activity, user_id: user3.id, 
                                            activity_updated_time: 6.days.ago)
        stub_stripe
        Payment.charge_all_users
        expect(user3.payments.last.bill_amount).to eq(50)
        expect(Payment.count).to eq(1)
      end
    end

    context "when users have previous payments" do
      it "should only charge users with a stripe customer id" do
        user2 = FactoryGirl.create(:user, stripe_customer_id: "nil")
        user3 =FactoryGirl.create(:user, charity_id: charity.id, created_at: 8.days.ago)
        FactoryGirl.create(:payment, user_id: user3.id, created_at: 5.days.ago)
        user3activity1 = FactoryGirl.create(:activity, user_id: user3.id, 
                                            activity_updated_time: 4.days.ago)
        user3activity2 = FactoryGirl.create(:activity, user_id: user3.id, 
                                            activity_updated_time: 6.days.ago)
        stub_stripe
        Payment.charge_all_users
        expect(user3.payments.last.bill_amount).to eq(50)
        expect(Payment.count).to eq(2)
      end
    end
  end

end
