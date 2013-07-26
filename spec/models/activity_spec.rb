require 'spec_helper'

describe Activity do
  let(:user1) { FactoryGirl.create(:user, :uid => "100006352424167") }
  let(:user2) { FactoryGirl.create(:user, :uid => "100006352424168") }
  let(:user3) { FactoryGirl.create(:user, :uid => "100006352424169") }

  let(:statuses_user1) {
    [{"status_id"=>1393634087524992, "time"=>1374754290, "uid"=>100006352424167, "message"=>"using FQL queries to limit by date and time"},
    {"status_id"=>1393631927525208, "time"=>1374754241, "uid"=>100006352424167, "message"=>"using FQL queries"}]
  }

  let(:statuses_user2) {
    [{"status_id"=>1393634087524993, "time"=>1374754290, "uid"=>100006352424168, "message"=>"using FQL queries to limit by date and time"}]
  }

  let(:statuses_user3) {
    [{"status_id"=>1393634087524294, "time"=>1374754292, "uid"=>100006352424169, "message"=>"using FQL queries to limit by date and time"}]
  }


  describe "METHOD 'create_statuses_for_user'" do
    before(:each) do
      start_time = Activity.start_time
      end_time = Activity.end_time
      user1.save!
      user2.save!
      user3.save!
      User.stub(:all).and_return([user1, user2, user3])
      user1.stub(:get_statuses).and_return(statuses_user1)
      user2.stub(:get_statuses).and_return(statuses_user2)
      user3.stub(:get_statuses).and_return(statuses_user3)
      User.count.should == 3
    end

    context "with no statuses already in the database" do
      it "should extract status data from the user and add statuses to activity table" do
        Activity.count.should == 0
        Activity.create_statuses
        Activity.count.should == 4
      end
    end

    context "with some statuses already in the database" do
      it "should not add a status that is already in the database" do
        Activity.create_statuses
        Activity.count.should == 4
        Activity.create_statuses
        Activity.count.should == 4
      end
    end
  end

end
