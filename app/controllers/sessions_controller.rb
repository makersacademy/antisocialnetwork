class SessionsController < ApplicationController

  def new
    @charities=Charity.all
  end

  def create
  	auth = request.env["omniauth.auth"]
  	user = User.find_by_provider_and_uid(auth["provider"], auth["uid"])
    if user
      session[:user_id] = user.id
      redirect_to user_path(user)
    else
      user = User.create_with_omniauth(auth)
      session[:user_id] = user.id
      redirect_to user_path(user)
    end
  end

  def destroy
  	session[:user_id] = nil
  	redirect_to root_url
  end

end
