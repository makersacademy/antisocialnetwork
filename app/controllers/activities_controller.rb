
class ActivitiesController < ApplicationController
  def show
  end

  def index
    @user_activities = Activity.in_range_for_user_counted_by_day_and_description(current_user)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @user_activities}
    end
  end

  def create
    user = User.find(session[:user_id])
    Activity.save_latest_activities_for_user(user, 30.day)
    redirect_to user_path(user)
  end
end
