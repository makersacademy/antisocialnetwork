class Activity < ActiveRecord::Base
  belongs_to :user

  def self.fetch_activities
    self.create_statuses
    # ...
  end
  
  def self.create_statuses
    User.all.to_a.each do |user|
      Activity.create_statuses_for_user(user)
    end
  end

private

  def self.create_statuses_for_user(user)
    user.get_statuses.each do |status|
      user.activities.create(
        uid: status["from"]["id"],
        activity_id: status["id"],
        activity_description: "status update",
        activity_updated_time: status["updated_time"],
        user_id: user.uid)
    end    
  end

end
