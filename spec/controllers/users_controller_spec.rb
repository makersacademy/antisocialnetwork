require 'spec_helper'

describe UsersController do

  describe "GET 'index'" do
    it "returns http success" do
      pending
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'new'" do
    it "returns http success" do
      pending
      get 'new'
      response.should be_success
    end
  end

  describe "GET 'create'" do
    it "returns http success" do
      pending
      get 'create'
      response.should be_success
    end
  end

  describe "GET 'show'" do
    it "returns http success" do
      pending
      get 'show'
      response.should be_success
    end
  end

  describe "GET 'edit'" do
    it "returns http success" do
      pending
    end
  end

  describe "creating a customer'" do
    it "should add customer id to database" do
      user = FactoryGirl.create(:user)
       Stripe::Customer.should_receive(:create).and_return(double(:id => '12345'))
       put :update, :id => user.id, :stripe_card_token => "tok_u5dg20Gra"
       user.reload
       expect(user.stripe_customer_id).to eq('12345')
    end
  end

  describe "GET 'destroy'" do
    it "returns http success" do
      pending
      get 'destroy'
      response.should be_success
    end
  end



end
