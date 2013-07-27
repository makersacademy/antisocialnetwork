class ActivitiesController < ApplicationController
  def show
  end

  def index
    render partial: "user_activities" 
  end

  def create
    user = User.find(session[:user_id])
    Activity.save_latest_activity_for_user(user, 30.day)
    redirect_to user_path(user)
  end
end
