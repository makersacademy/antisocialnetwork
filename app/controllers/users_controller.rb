require 'stripe'

class UsersController < ApplicationController
  def index
  end

  def show
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    user = User.find(params[:id])
    customer = Stripe::Customer.create(
                  :description => "New customer",
                  :card => params[:stripe_card_token] )
    user.stripe_customer_id = customer.id    
    if user.save
      redirect_to user_path(user), :notice => "Your payment has been authorized! Thank-you!"
    else
      redirect_to user_path(user), :notice => "Something went wrong! Please try again!"
    end  
  end

  def destroy
    redirect_to 'index'
  end
  
end
