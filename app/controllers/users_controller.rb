require 'stripe'

class UsersController < ApplicationController
  def index
  end

  def new
  end

  def create
  end

  def show
  end

  def edit
  end

  def update
    user = User.find(params[:user_id])
    customer = Stripe::Customer.create(
                  :description => "New customer",
                  :card => params[:stripe_card_token] 
               )
    user.customer_id = params[:stripe_card_token]
    if user.save
      flash[:notice] = "Thank-you!"
      redirect_to user_path(user)
    else
      flash[:notice] = "Something went wrong! Please try again!"
      redirect_to user_path(user)
    end  
  end

  def destroy
  end
end
