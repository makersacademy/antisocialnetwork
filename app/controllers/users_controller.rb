require 'stripe'

class UsersController < ApplicationController
  def index
  end

  def show
    @user = User.find(params[:id])
    @charities = Charity.all
  end

  def edit
  end

  def update
    user = User.find(params[:id])
    if params[:stripe_card_token]
      update_card(user, params[:stripe_card_token]) 
    end
    if params[:charity_id]
      update_charity(user, params[:charity_id])
    end 
  end

  def destroy
    redirect_to 'index'
  end

private

  def update_card(user, card_token)  
    customer = Stripe::Customer.create(
                    :description => "New customer",
                    :card => card_token)
    user.stripe_customer_id = customer.id  
    if user.save
      redirect_to user_path(user), :notice => "Your payment has been authorized! Thank-you!"
    else
      redirect_to user_path(user), :notice => "Something went wrong! Please try again!"
    end    
  end 

  def update_charity(user, charity_id)
    user.charity_id = charity_id
    if user.save
      redirect_to user_path(user)
    else
      redirect_to user_path(user), :notice => "Something went wrong! Please select your charity again!"
    end  
  end
end
