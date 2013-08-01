require 'stripe'

class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @charities = Charity.all
  end

  def update
    user = User.find(params[:id])
    update_card(user, params[:stripe_card_token]) if params[:stripe_card_token]
    update_charity(user, params[:charity_id]) if params[:charity_id]
    unsubscribe(user) if params[:unsubscribe]
    redirect_to user_path(user)
  end

  def unsubscribe
    user = User.find(params[:id])
    user.stripe_customer_id = nil
    flash[:notice] = user.save ? "Your donations have been stopped" : "Something went wrong! Please try again!"
    redirect_to user_path(user)
  end

  def destroy
    redirect_to root_path
  end

private

  def update_card(user, card_token)
    begin
      if user.stripe_customer_id
        cu = Stripe::Customer.retrieve(user.stripe_customer_id)
        cu.description = "Updated user card"
        cu.card = card_token
        user.last_four_digits_of_credit_card = cu.cards.data.first["last4"]
        flash[:notice] = cu.save && user.save ? "Your card has been updated!" : "Something went wrong! Please try again!"
      else 
        cu = Stripe::Customer.create(:description => "New customer", :card => card_token)
        user.stripe_customer_id = cu.id 
        user.last_four_digits_of_credit_card = cu.cards.data.first["last4"]
        flash[:notice] = user.save ? "Your card has been added!" : "Something went wrong! Please try again!"
      end
    rescue
      flash[:notice] = "Something went wrong! Please try again!"
    end
  end


  def update_charity(user, charity_id)
    user.charity_id = charity_id
    flash[:notice] = "Something went wrong! Please select your charity again!" unless user.save
  end

end
