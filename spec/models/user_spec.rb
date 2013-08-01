require 'spec_helper'

describe User do
  let(:omni_auth_hash) do 
    {
      "provider" => 'facebook',
      "uid" => '1234567',
      "info" => {
        "nickname" => 'jbloggs',
        "email" => 'joe@bloggs.com',
        "name" => 'Joe Bloggs',
        "first_name" => 'Joe',
        "last_name" => 'Bloggs',
        "image" => 'http://graph.facebook.com/1234567/picture?type=square',
        "urls" => { :Facebook => 'http://www.facebook.com/jbloggs' },
        "location" => 'Palo Alto, California',
        "verified" => true
      },
      "credentials" => {
        "token" => 'ABCDEF...', # OAuth 2.0 access_token, which you may wish to store
        "expires_at" => 1321747205, # when the access token expires (it always will)
        "expires" => true # this will always be true
      },
      "extra" => {
        "raw_info" => {
          "id" => '1234567',
          "name" => 'Joe Bloggs',
          "first_name" => 'Joe',
          "last_name" => 'Bloggs',
          "link" => 'http://www.facebook.com/jbloggs',
          "username" => 'jbloggs',
          "location" => { :id => '123456789', :name => 'Palo Alto, California' },
          "gender" => 'male',
          "email" => 'joe@bloggs.com',
          "timezone" => -8,
          "locale" => 'en_US',
          "verified" => true,
          "updated_time" => '2011-11-11T06:21:03+0000'
        }
      }
    }
  end

  let(:user) do
    FactoryGirl.create(:user,
      name: "John Smith",
      email: "doubled@gmail.com",
      provider: "facebook",
      uid: "100006352424167",
      fb_access_token: "ABCDEF...",
      fb_access_expires_at: "1321747205"
    )
  end

  let(:start_time) {1374682390}
  let(:end_time) {1374754290}

  describe "METHOD 'create_with_omniauth'" do
    context "with valid details" do
      it "should add the user to the database" do
        User.count.should == 0
        user = User.create_with_omniauth(omni_auth_hash)
        user.should be_valid
        User.count.should == 1
      end
    end
  end

  describe "METHOD 'Facebook'" do
    context "when facebook token is valid" do
      before(:each) do
        omni_auth_hash["credentials"]["expires_at"] = (DateTime.now + 2.hours).to_i
      end

      context "when passed a block" do
        it 'should yield a Koala Favebook API instance to the block' do
          user = User.create_with_omniauth(omni_auth_hash)
          expect(user.facebook { |fb| fb }).to be_a_kind_of Koala::Facebook::API
        end
      end

      context "when no block is passed" do
        it 'should return a Koala Favebook API instance' do
          user = User.create_with_omniauth(omni_auth_hash)
          expect(user.facebook).to be_a_kind_of Koala::Facebook::API
        end
      end
    end

    context "when facebook token has expired" do
      it "should return nil" do
        user = User.create_with_omniauth(omni_auth_hash)
        expect(user.facebook { |fb| raise Koala::Facebook::APIError.new(403,"Invalid Token") }).to be_nil
      end
    end
  end

  describe "activity in payment cycle" do
    
    before(:each) do
      activity1 = FactoryGirl.create(
        :activity, :user_id => user.id,
        :activity_description => "add link",
        :activity_updated_time => "2013-07-24 12:13:14")
      activity2 = FactoryGirl.create(
        :activity, :user_id => user.id,
        :activity_description => "add album",
        :activity_updated_time => "2013-07-25 12:13:14")
      activity3 = FactoryGirl.create(
        :activity, :user_id => user.id,
        :activity_description => "add link",
        :activity_updated_time => "2013-07-26 12:13:14")
      activity4 = FactoryGirl.create(
        :activity, :user_id => user.id,
        :activity_description => "add link",
        :activity_updated_time => "2013-07-20 12:13:14")
      activity5 = FactoryGirl.create(
        :activity, :user_id => user.id,
        :activity_description => "add photo",
        :activity_updated_time => "2013-07-24 12:13:14")
    end
    
    describe "METHOD 'activity_in_payment_period'" do
      it "should return a hash of activities with counts of the number within the given period" do
        activities_array = {"add link"=>1, "add album" =>1, "add photo"=>1}
        date_range = DateTime.parse("2013-07-24")..DateTime.parse("2013-07-26")
        user.activity_in_payment_period(date_range).should == activities_array
      end
    end

    describe "METHOD 'chargeable_activity_in_payment_period'" do
      context "when the user joined during the payment period" do
        it "should return a hash of activities with counts of the number within the given period" do
          activities_array = {"add link" =>1}
          date_range = DateTime.parse("2013-07-24")..DateTime.parse("2013-07-26")
          User.any_instance.stub(:created_at).and_return(DateTime.parse("2013-07-25 13:00"))
          user.chargeable_activity_in_payment_period(date_range).should == activities_array
        end
      end
    end

  end
end

