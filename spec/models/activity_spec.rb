require 'spec_helper'

describe Activity do
  let(:user1) { FactoryGirl.create(:user) }
  let(:user2) { FactoryGirl.create(:user, :uid => "100006352424168") }
  let(:user3) { FactoryGirl.create(:user, :uid => "100006352424169") }
  let(:statuses_user){[{ "id"=>"1392923067596094", 
                          "from"=>{"name"=>"Dario D", "id"=>"100006352424167"}, 
                          "message"=>"5:30", 
                          "updated_time"=>"2013-07-24T16:13:10+0000"}, 
                        { "id"=>"1391975747690826", 
                          "from"=>{"name"=>"Dario D", "id"=>"100006352424167"}, 
                          "message"=>"Test", 
                          "updated_time"=>"2013-07-23T16:34:31+0000"}, 
                        { "id"=>"1391861297702271", 
                          "from"=>{"name"=>"Dario D", "id"=>"100006352424167"}, 
                          "message"=>"Coding a great facebook app", 
                          "updated_time"=>"2013-07-23T14:39:31+0000"}]}


  describe "METHOD 'create_statuses_for_user'" do
    context "with no statuses already in the database" do
      it "should extract status data from the user and add statuses to activity table" do
        User.any_instance.stub(:get_statuses).and_return statuses_user
        user1.save!
        user2.save!
        user3.save!
        User.count.should == 3
        Activity.count.should == 0
        Activity.create_statuses
        Activity.count.should == 9
      end
    end
  end

end
