class UsersController < ApplicationController
  def index
  end

  def show
  end

  def edit
  end

  def update
    redirect_to 'show'
  end

  def destroy
    redirect_to 'index'
  end
end
