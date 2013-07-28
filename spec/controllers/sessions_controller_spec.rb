require 'spec_helper'

describe SessionsController do

  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      response.should be_success
      response.should render_template("new")
    end
  end

  describe "GET 'create'" do
    context "when user is signing in" do
      context "for the first time" do

        let(:new_user){User.new}
        
        before(:each) do
          request.stub(:env).and_return(
            {"omniauth.auth" => {"provider" => "facebook", "uid" => "593405141"}})
        end
        
        it "creates the user" do
          User.should_receive(:find_by_provider_and_uid).and_return(nil)
          User.should_receive(:create_with_omniauth).and_return(new_user)
          Activity.stub(:save_latest_activities_for_user).and_return(nil)
          get 'create', :provider => 'facebook'
        end

        it "should redirect_to the user show page" do
          User.stub(:find_by_provider_and_uid).and_return(nil)
          User.stub(:create_with_omniauth).and_return(new_user)
          get 'create', :provider => 'facebook'
          response.should redirect_to user_path(new_user)
        end
      end

      context "having already signed in before" do
        
        before(:each) do
          request.stub(:env).and_return(
            {"omniauth.auth" => {"provider" => "facebook", "uid" => "593405141"}})
        end

        it "retrieves the existing user" do
          User.should_receive(:find_by_provider_and_uid).and_return(User.new) # this would be an existing user
          get 'create', :provider => 'facebook'
          response.should redirect_to user_path(User.last)
        end

        it "does NOT retrieve the latest activity for the user" do
          User.should_receive(:find_by_provider_and_uid).and_return(User.new)
          Activity.should_not_receive(:save_latest_activities_for_user)
          get 'create', :provider => 'facebook'
        end
      end
    end
  end

  describe "GET 'destroy'" do
    it "returns http success" do
      get 'destroy'
      session[:user_id].should == nil
      response.should redirect_to root_url
    end
  end

end
