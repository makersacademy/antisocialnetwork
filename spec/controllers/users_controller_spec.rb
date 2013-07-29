require 'spec_helper'

describe UsersController do

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

    it "should update the charity" do
      user = FactoryGirl.create(:user)
      put :update, :id => user.id, :charity_id => 1
      response.should redirect_to user_path(user)
      user.reload
      expect(user.charity_id).to eq(1)
    end
  end

  describe "DELETE 'destroy'" do
    it "redirects to index" do
      delete 'destroy', :id => 1
      response.should redirect_to :root
    end

    it "deletes the user from the database" do
      pending "not clear at this point whether users should be deleted or just deactivated"
      delete 'destroy', :id => 1
    end
  end

end
