
class Activity < ActiveRecord::Base
  belongs_to :user

  # Hash constant that maps the activity field names recognized by this app to the facebook column names
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
    :photo => {
      :uid => "owner",
      :activity_id => "pid",
      :activity_updated_time => "modified",
      :activity_description => "add or modify photo"
    },
    :album => {
      :uid => "owner",
      :activity_id => "aid",
      :activity_updated_time => "created",
      :activity_description => "add album"
    },
    :event => {
      :uid => "creator",
      :activity_id => "eid",
      :activity_updated_time => "update_time",
      :activity_description => "add or modify event"
    },
    :checkin => {
      :uid => "author_uid",
      :activity_id => "checkin_id",
      :activity_updated_time => "timestamp",
      :activity_description => "checkin"
    },
    :link => {
      :uid => "owner",
      :activity_id => "link_id",
      :activity_updated_time => "created_time",
      :activity_description => "add link"
    },
    :video => {
      :uid => "owner",
      :activity_id => "vid",
      :activity_updated_time => "created_time",
      :activity_description => "upload video"
    }
  }

  def self.save_latest_activities(time_span)
    User.all.each do |user|
      Activity.save_latest_activities_for_user(user, time_span)
    end
  end

  def self.save_latest_activities_for_user(user, time_span)
    Activity.activities_for_user(user, time_span).each do |activity|      
      user.activities.create(activity) unless Activity.find_by_activity_id(activity[:activity_id].to_s)
    end
  end

private


  def self.activities_for_user(user, time_span)
    Activity::FACEBOOK_TABLES.map do |table_name, fields|
      processed_activities_for_user(table_name, user, time_span)
    end.inject(:+)
  end

  def self.processed_activities_for_user(table_name, user, time_span)
      raw_activities_from_facebook(table_name, user, time_span).map do |raw_activity| 
        processed_activity(raw_activity, table_name)
      end
  end

  def self.raw_activities_from_facebook(table_name, user, time_span)
    user.facebook { |fb| fb.fql_query(fql_string(table_name, user, time_span)) } || []
  end

  def self.processed_activity(raw_activity, table_name)
    activity = raw_activity.map do |facebook_field, activity_attribute|
      [ Activity::FACEBOOK_TABLES[table_name].key(facebook_field), activity_attribute ]
    end
    activity = Hash[activity]
    activity[:activity_updated_time] = Time.at(activity[:activity_updated_time]).utc.to_datetime
    activity.merge!({:activity_description => Activity::FACEBOOK_TABLES[table_name][:activity_description]})
  end

  def self.fql_string(table_name, user, time_span)
    "SELECT #{FACEBOOK_TABLES[table_name][:activity_id]}, #{FACEBOOK_TABLES[table_name][:activity_updated_time]}, #{FACEBOOK_TABLES[table_name][:uid]} FROM #{table_name} WHERE #{FACEBOOK_TABLES[table_name][:uid]} = #{user.uid} AND #{FACEBOOK_TABLES[table_name][:activity_updated_time]} > #{start_time(time_span)} AND #{FACEBOOK_TABLES[table_name][:activity_updated_time]} < #{end_time}"
  end

  def self.start_time(time_span)
    (Time.now.utc - time_span).to_i
  end

  def self.end_time
    Time.now.utc.to_i
  end

end


