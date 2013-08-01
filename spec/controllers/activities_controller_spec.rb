
require 'spec_helper'

describe ActivitiesController do

  describe "GET 'show'" do
    it "returns http success" do
      get 'show', :id => 1
      response.should render_template "show"
      response.should be_success
    end
  end

  describe "GET 'index.json'" do
    let(:user1) { FactoryGirl.create(:user, :uid => "100006352424167") }
    let(:user2) { FactoryGirl.create(:user, :uid => "100006352424168") }
    before(:each) do
      session[:user_id] = user1.id
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
    end

    it "returns http success" do
      get 'index', :format => :json
    end
  end
  describe "POST 'create'" do

    let(:current_user1){User.create}

    context "user signing in for the first time" do

      before(:each) do
        session[:user_id] = current_user1.id
        User.any_instance.stub(:created_at).and_return(Time.now)
      end
      
      it "should retrieve the users historic facebook data" do
        Activity.should_receive(:save_latest_activities_for_user).with(current_user1, 7.day).and_return(nil)
        post 'create'
      end

      it "should redirect to the user profile page" do
        Activity.stub(:save_latest_activities_for_user).with(current_user1, 7.day).and_return(nil)
        post 'create'
        response.should redirect_to user_path(current_user1)
      end
    end

    context "user signing in the next time" do

      before(:each) do
        session[:user_id] = current_user1.id
        User.any_instance.stub(:created_at).and_return(2.days.ago)
      end

      it "should NOT retrieve the users historic facebook data" do
        Activity.should_not_receive(:save_latest_activities_for_user)
        post 'create'
      end

      it "should redirect to the user profile page" do
        post 'create'
        response.should redirect_to user_path(current_user1)
      end
    end

  end
end
