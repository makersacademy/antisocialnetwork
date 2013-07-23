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
    user.save
  end

  def destroy
  end
end
