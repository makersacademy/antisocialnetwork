class Activity < ActiveRecord::Base
  belongs_to :user

  def self.fetch_activities
    self.create_statuses
    # ...
  end
  
  def self.create_statuses
    User.all.each do |user|
      Activity.create_statuses_for_user(user)
    end
  end

private

  def self.create_statuses_for_user(user)
    user.get_statuses(Activity.start_time, Activity.end_time).each do |status|      
      unless Activity.find_by_activity_id(status["status_id"].to_s)
        user.activities.create(
          activity_id: status["status_id"].to_s ,
          uid: status["uid"].to_s,
          activity_description: "status update",
          activity_updated_time: Time.at(status["time"]).utc.to_datetime )
      end
    end
  end

  def self.start_time
    (DateTime.now - 2.hour).to_i
  end

  def self.end_time
    DateTime.now.to_i
  end

end


