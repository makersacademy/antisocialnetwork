require 'spec_helper'

class ApplicationHelperInstance
  include ApplicationHelper
end

describe ApplicationHelper do
  let(:app_helper){ApplicationHelperInstance.new}
  let(:the_user){FactoryGirl.create(:user)}

  describe "METHOD users_current_payment_period" do
    
    context "when a new user hasn't made a payment" do
      it "returns the period since joining" do
        joined_date = 2.day.ago
        the_user.stub_chain("payments.last.created_at").and_return(joined_date)
        the_user.stub_chain("payments.length").and_return(0)
        the_user.stub(:created_at).and_return(joined_date)
        Time.stub(:now).and_return(Date.today)
        expected_date_range = joined_date..Time.now
        
      end
    end

    context "when a signed up user has made a payment" do
      it "returns the period since the last payment" do
        date_of_last_payment = 3.day.ago
        the_user.stub_chain("payments.last.created_at").and_return(date_of_last_payment)
        the_user.stub_chain("payments.length").and_return(1)
        Time.stub(:now).and_return(Date.today)
        expected_date_range = date_of_last_payment..Time.now
        app_helper.users_current_payment_period(the_user).should == expected_date_range
      end
    end

  end
end