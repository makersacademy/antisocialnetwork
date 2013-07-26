require 'spec_helper'


describe Activity do
  let(:user1) { FactoryGirl.create(:user, :uid => "100006352424167") }
  let(:user2) { FactoryGirl.create(:user, :uid => "100006352424168") }
  let(:user3) { FactoryGirl.create(:user, :uid => "100006352424169") }

  let(:user1_status) {
    [{"status_id" =>1393634087524992, 
      "time" => 1374754290, 
      "uid" => 100006352424167},
     {"status_id" =>1393631927525208, 
      "time" => 1374754241, 
      "uid" => 100006352424167}]
  }

  let(:user1_location_post) {
    [{"post_id" =>1393634087524992, 
      "timestamp" => 1374754290, 
      "author_uid" => 100006352424167},
     {"post_id" =>1393631927525208, 
      "timestamp" => 1374754241, 
      "author_uid" => 100006352424167}]
  }

  let(:user2_status) {
    [{"status_id" => 1393634087524993, 
      "time" => 1374754290, 
      "uid" => 100006352424168}]
  }

  let(:user3_status) {
    [{"status_id" => 1393634087524294, 
      "time" => 1374754292, 
      "uid" => 100006352424169}]
  }

  describe "METHOD 'save_latest_activity'" do
    before(:each) do
      # user1.save!
      # user2.save!
      # user3.save!
      User.stub(:all).and_return([user1, user2, user3])
      User.count.should == 3

      Activity.stub(:fetch_activity_from_facebook).with(:status, user1).and_return(user1_status)
      Activity.stub(:fetch_activity_from_facebook).with(:location_post, user1).and_return(user1_location_post)

      Activity.stub(:fetch_activity_from_facebook).with(:status, user2).and_return(user2_status)
      Activity.stub(:fetch_activity_from_facebook).with(:location_post, user2).and_return([])

      Activity.stub(:fetch_activity_from_facebook).with(:status, user3).and_return(user3_status)
      Activity.stub(:fetch_activity_from_facebook).with(:location_post, user3).and_return([])
    end

    context "with no statuses already in the database" do
      it "should extract status data from the user and add statuses to activity table" do
        Activity.count.should == 0
        Activity.save_latest_activity
        Activity.count.should == 4
      end
    end

    context "with some statuses already in the database" do
      it "should not add a status that is already in the database" do
        Activity.save_latest_activity
        Activity.count.should == 4
        Activity.save_latest_activity
        Activity.count.should == 4
      end
    end

  end

end
