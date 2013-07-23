require 'spec_helper'

describe User do

  describe "METHOD 'create_with_omniauth'" do
    context "with valid details" do
      it "should add the user to the database" do
        User.count.should == 0
        hash = {"provider" => 'facebook', 
                "uid" => '590945141',
                "info" => {"name" => 'James Caan', "email" => 'james@gmail.com'}}
        user = User.create_with_omniauth(hash)
        user.should be_valid
        User.count.should == 1
      end
    end
  end

end