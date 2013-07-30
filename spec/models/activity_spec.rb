
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

  let(:user1_photo) {
    [{"pid" =>1393634087524921, 
      "modified" => 1374754290, 
      "owner" => 100006352424167},
     {"pid" =>1393631927525222, 
      "modified" => 1374754241, 
      "owner" => 100006352424167}]
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

  let(:time_span) { 1.hour }

  before(:each) do
    User.stub(:all).and_return([user1, user2, user3])
    User.count.should == 3
    

    Activity.stub(:raw_activities_from_facebook).and_return([])

    Activity.stub(:raw_activities_from_facebook).with(:status, user1, time_span).and_return(user1_status)
    Activity.stub(:raw_activities_from_facebook).with(:photo, user1, time_span).and_return(user1_photo)

    Activity.stub(:raw_activities_from_facebook).with(:status, user2, time_span).and_return(user2_status)
    Activity.stub(:raw_activities_from_facebook).with(:photo, user2, time_span).and_return([])

    Activity.stub(:raw_activities_from_facebook).with(:status, user3, time_span).and_return(user3_status)
    Activity.stub(:raw_activities_from_facebook).with(:photo, user3, time_span).and_return([])
  end

  describe "METHOD 'save_latest_activities_for_user'" do

    context "with no statuses already in the database" do
      it "should extract status data from the user and add statuses to activity table" do
        Activity.count.should == 0
        Activity.save_latest_activities_for_user(user1, time_span)
        Activity.count.should == 4
      end
    end

    context "with some statuses already in the database" do
      it "should not add a status that is already in the database" do
        Activity.save_latest_activities_for_user(user1, time_span)
        Activity.count.should == 4
        Activity.save_latest_activities_for_user(user1, time_span)
        Activity.count.should == 4
      end
    end

  end

  describe "METHOD 'save_latest_activities'" do

    context "with no statuses already in the database" do
      it "should extract status data from the user and add statuses to activity table" do
        Activity.count.should == 0
        Activity.save_latest_activities(time_span)
        Activity.count.should == 6
      end
    end

    context "with some statuses already in the database" do
      it "should not add a status that is already in the database" do
        Activity.save_latest_activities(time_span)
        Activity.count.should == 6
        Activity.save_latest_activities(time_span)
        Activity.count.should == 6
      end
    end

  end

  describe "METHOD 'in_range_counted_by_day_and_description'" do
    it "should return an array of results scoped to a particular user and date range" do
      user1activity1 = FactoryGirl.create(
        :activity, :user_id => user1.id,
        :activity_description => "add link",
        :activity_updated_time => "2013-07-24 12:13:14")
      user1activity2 = FactoryGirl.create(
        :activity, :user_id => user1.id,
        :activity_description => "add album",
        :activity_updated_time => "2013-07-25 12:13:14")
      user1activity3 = FactoryGirl.create(
        :activity, :user_id => user1.id,
        :activity_description => "add link",
        :activity_updated_time => "2013-07-30 12:13:14")
      user1activity4 = FactoryGirl.create(
        :activity, :user_id => user1.id,
        :activity_description => "add link",
        :activity_updated_time => "2013-07-20 12:13:14")
      user2activity1 = FactoryGirl.create(
        :activity, :user_id => user2.id,
        :activity_description => "add link",
        :activity_updated_time => "2013-07-24 12:13:14")

      Activity.count.should == 5

      expected_result = [ 
        {"date"=>"2013-07-25", "status_update"=>"0", "add_or_modify_photo"=>"0", "add_album"=>"1", "add_or_modify_event"=>"0", "checkin"=>"0", "add_link"=>"0", "upload_video"=>"0"},
        {"date"=>"2013-07-24", "status_update"=>"0", "add_or_modify_photo"=>"0", "add_album"=>"0", "add_or_modify_event"=>"0", "checkin"=>"0", "add_link"=>"1", "upload_video"=>"0"}]

      start_date = Time.new(2013,07,23).beginning_of_day
      end_date = Time.new(2013,07,26).beginning_of_day
      puts "Activity.all.to_a.inspect #{Activity.all.to_a.inspect}"
      puts "Activity.count #{Activity.count}"
      expect(Activity.in_range_counted_by_day_and_description(user1, start_date, end_date).to_a).to eql expected_result
    end
  end

end
