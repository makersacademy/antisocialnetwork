3require 'spec_helper'

describe UsersController do

  describe "GET 'index'" do
    it "renders a list of users" do
      pending "requirement to show users is not yet established"
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'show'" do
    it "renders the user show page" do
      user = FactoryGirl.create(:user)
      get 'show', :id => user.id
      response.should render_template 'show'
      response.should be_success
    end
  end

  describe "PUT 'update" do
    it "should add the stripe customer id to database" do
       user = FactoryGirl.create(:user)
       Stripe::Customer.should_receive(:create).and_return(double(:id => '12345'))
       put :update, :id => user.id, :stripe_card_token => "tok_u5dg20Gra"
       response.should redirect_to user_path(user)
       user.reload
       expect(user.stripe_customer_id).to eq('12345')
    end
  end

  describe "DELETE 'destroy'" do
    it "redirects to index" do
      delete 'destroy', :id => 1
      response.should redirect_to 'index'
    end

    it "deletes the user from the database" do
      pending "not clear at this point whether users should be deleted or just deactivated"
      delete 'destroy', :id => 1
    end
  end

end
