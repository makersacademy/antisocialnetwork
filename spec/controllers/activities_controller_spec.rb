
require 'spec_helper'

describe ActivitiesController do

  describe "GET 'show'" do
    it "returns http success" do
      get 'show', :id => 1
      response.should render_template "show"
      response.should be_success
    end
  end

  describe "GET 'index'" do
    it "returns http success" do
      pending "implementation not yet clear"
      get 'index'
      response.should render_template "activities/_user_activities"
      response.should be_success
    end
  end

  context "user signing in for the first time" do

    let(:current_user1){User.create}

    before(:each) do
      session[:user_id] = current_user1.id
    end

    describe "POST 'create'" do  
      it "should retrieve the users historic facebook data" do
        Activity.should_receive(:save_latest_activities_for_user).with(current_user1, 30.day).and_return(nil)
        post 'create'
      end

      it "should redirect to the user profile page" do
        Activity.stub(:save_latest_activities_for_user).with(current_user1, 30.day).and_return(nil)
        post 'create'
        response.should redirect_to user_path(current_user1)
      end
    end
  end

end
