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
        it "creates the user" do
          request.stub(:env).and_return(
            {"omniauth.auth" => {"provider" => "facebook", "uid" => "590905141"}}
          )
          User.should_receive(:find_by_provider_and_uid).and_return(nil)
          User.should_receive(:create_with_omniauth).and_return(User.new)
          get 'create', :provider => 'facebook'
          response.should redirect_to user_path(User.last)
        end
      end

      context "having already signed in before" do
        it "retrieves the existing user" do
          request.stub(:env).and_return(
            {"omniauth.auth" => {"provider" => "facebook", "uid" => "590905141"}}
          )
          User.should_receive(:find_by_provider_and_uid).and_return(User.new) # this would be an existing user
          get 'create', :provider => 'facebook'
          response.should redirect_to user_path(User.last)
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
