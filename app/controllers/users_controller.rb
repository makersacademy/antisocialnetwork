require 'stripe'

class UsersController < ApplicationController
  def index
  end

  def show
  end

  def edit
    @user = User.find(params[:id])
  end

  def updatebundle 
    user = User.find(params[:id])
    customer = Stripe::Customer.create(
                  :description => "New customer",
                  :card => params[:stripe_card_token] 
               )
    user.stripe_customer_id = customer.id    
    if user.save
      flash[:notice] = "Thank-you!"
      redirect_to user_path(user)
    else
      flash[:notice] = "Something went wrong! Please try again!"
      redirect_to user_path(user)
    end  
  end

  def destroy
    redirect_to 'index'
  end
  
end
