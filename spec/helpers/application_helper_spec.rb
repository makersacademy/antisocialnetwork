require 'spec_helper'

class ApplicationHelperInstance
  include ApplicationHelper
end

describe ApplicationHelper do
  let(:app_helper){ApplicationHelperInstance.new}
  let(:the_user){FactoryGirl.create(:user)}

  describe "METHOD 'current_period_date_range'" do
    it "should delegate to the Payment model and return a formatted date range string" do
      test_date_range = 1.day.ago..Time.now
      Payment.should_receive(:users_current_payment_period).twice.with(the_user).and_return(test_date_range)
      expected_result = "#{test_date_range.first.strftime("%a %d-%b-%Y %H:%M")} - #{test_date_range.last.strftime("%a %d-%b-%Y %H:%M")}"
      expect(app_helper.current_period_date_range(the_user)).to eql expected_result
    end

  end

  describe "METHOD recent_activity_cost" do

    before(:each) do
      session[:user_id] = the_user.id
      activity1 = FactoryGirl.create(
        :activity, :user_id => the_user.id,
        :activity_description => "add link",
        :activity_updated_time => 3.days.ago)
      activity2 = FactoryGirl.create(
        :activity, :user_id => the_user.id,
        :activity_description => "add album",
        :activity_updated_time => 3.days.ago)
      activity3 = FactoryGirl.create(
        :activity, :user_id => the_user.id,
        :activity_description => "add link",
        :activity_updated_time => 1.day.ago)
    end

    context "when a new user hasn't made a payment" do
      it "should charge the customer from the date they joined" do
        joined_date = 2.day.ago
        the_user.stub(:created_at).and_return(joined_date)
        the_user.stub_chain("payments.length").and_return(0)
        app_helper.recent_activity_cost(the_user, 50).should == 1 * 50 / 100.00
      end
    end

    context "when a user has made a payment" do
      it "should charge them from the date of the last payment" do
        date_of_last_payment = 4.day.ago
        joined_date = 2.day.ago
        the_user.stub_chain("payments.last.created_at").and_return(date_of_last_payment)
        the_user.stub(:created_at).and_return(joined_date)
        the_user.stub_chain("payments.length").and_return(1)
        app_helper.recent_activity_cost(the_user, 50).should == 3 * 50 / 100.00
      end 
    end

  end

end