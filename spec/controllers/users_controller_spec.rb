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
    context "when user adding their card details for the first time" do
      it "should add the stripe customer id to database" do
        user = FactoryGirl.create(:user, stripe_customer_id: nil)
        Stripe::Customer.should_receive(:create).and_return(double(:id => '12345'))
        put :update, :id => user.id, :stripe_card_token => "tok_u5dg20Gra"
        response.should redirect_to user_path(user)
        user.reload
        expect(user.stripe_customer_id).to eq('12345')
      end
    end

    context "when user updating their card details" do
      it "should not update the customer id" do
        user = FactoryGirl.create(:user)
        stripe_customer = double("Stripe_Customer")
        stripe_customer.should_receive(:description=).with("Updated user card").at_least(:once)
        stripe_customer.should_receive(:card=).at_least(:once)
        stripe_customer.should_receive(:save)
        Stripe::Customer.should_receive(:retrieve).and_return(stripe_customer)
        put :update, :id => user.id, :stripe_card_token => "tok_u5dg20Gra"
        response.should redirect_to user_path(user)
        user.reload
        expect(user.stripe_customer_id).to eq('scid 453443')
      end
    end

    it "should update the charity" do
      user = FactoryGirl.create(:user)
      put :update, :id => user.id, :charity_id => 1
      response.should redirect_to user_path(user)
      user.reload
      expect(user.charity_id).to eq(1)
    end
  end

  describe "POST 'unsubscribe'" do
    it "should delete the users stripe customer id" do
      user = FactoryGirl.create(:user)
      post :unsubscribe, :id => user.id
      response.should redirect_to user_path(user)
      user.reload
      expect(user.stripe_customer_id).to be_nil
    end
  end  


end
