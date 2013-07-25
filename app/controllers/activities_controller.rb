class ActivitiesController < ApplicationController
  def show
  end

  def index
    render partial: "user_activities"
  end

  def create
  end
end
