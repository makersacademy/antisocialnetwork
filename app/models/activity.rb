class Activity < ActiveRecord::Base
  belongs_to :user

  # Number of hours of Activity back data to fetch
  HOURS_OF_DATA = 1

  # Hash constant that stores the facebook table columns in the following format
  # { [facebook table name] => {
  #   :uid => [facebook column name for uid], 
  #   :activity_id => [facebook column name for activity_id], 
  #   :activity_updated_time => [facebook column name for activity_updated_time], 
  #   :activity_description => [How this activity is to be described in the database]}
  FACEBOOK_TABLES = {
    :status => {
      :uid => "uid", 
      :activity_id => "status_id", 
      :activity_updated_time => "time", 
      :activity_description => "status update"
    },
    :location_post => {
      :uid => "author_uid", 
      :activity_id => "post_id", 
      :activity_updated_time => "timestamp", 
      :activity_description => "location post"
    }
  }

  YAML.load('.yml')

  def self.save_latest_activity
    User.all.each do |user|
      Activity.save_latest_activity_for_user(user)
    end
  end

  private

  # Fetches a user's activities
  # and saves them in the database unless they are already in the database
  def self.save_latest_activity_for_user(user)
    Activity.fetch_activities_for_user(user).each do |activity|      
      user.activities.create(activity) unless Activity.find_by_activity_id(activity[:activity_id].to_s)
    end
  end

  def self.fetch_activities_for_user(user)
    Activity::FACEBOOK_TABLES.map do |table_name, fields|
      fetch_formatted_activity_for_user(table_name, user)
    end.inject(:+)
  end

  def self.fetch_formatted_activity_for_user(table_name, user)
      fetch_activity_from_facebook(table_name, user).map do |raw_activity| 
        format_activity(raw_activity, table_name)
      end
  end

  def self.fetch_activity_from_facebook(table_name, user)
    user.facebook { |fb| fb.fql_query(fql_string(table_name, user)) } || []
  end

  # Converts an activity to a standard format
  # for storage in the database
  def self.format_activity(raw_activity, table_name)
    formatted_activity = raw_activity.map do |facebook_field, activity_attribute|
      [ Activity::FACEBOOK_TABLES[table_name].key(facebook_field), activity_attribute ]
    end
    formatted_activity = Hash[formatted_activity]
    formatted_activity[:activity_updated_time] = Time.at(formatted_activity[:activity_updated_time]).utc.to_datetime
    formatted_activity.merge!({:activity_description => Activity::FACEBOOK_TABLES[table_name][:activity_description]})
  end

  # Constructs a facebook query language query string
  # by substituting table specific table name and table columns into a standardized query string
  # Facebook table specifics are retrieved from the FACEBOOK_TABLES hash
  def self.fql_string(table_name, user)
    "SELECT #{FACEBOOK_TABLES[table_name][:activity_id]}, #{FACEBOOK_TABLES[table_name][:activity_updated_time]}, #{FACEBOOK_TABLES[table_name][:uid]} FROM #{table_name} WHERE #{FACEBOOK_TABLES[table_name][:uid]} = #{user.uid} AND #{FACEBOOK_TABLES[table_name][:activity_updated_time]} > #{start_time} AND #{FACEBOOK_TABLES[table_name][:activity_updated_time]} < #{end_time}"
  end

  # Returns a UNIX epoque time based on the current time
  def self.start_time
    (DateTime.now - HOURS_OF_DATA.hour).to_i
  end

  # Returns a UNIX epoque time based on the current time
  def self.end_time
    DateTime.now.to_i
  end

end


