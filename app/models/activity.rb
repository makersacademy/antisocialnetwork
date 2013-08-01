
class Activity < ActiveRecord::Base
  belongs_to :user


  # scope :recent, where(:created_at >=, 7.days.ago )
  # date = DateTime.now.beginning_of_day
  #   user.activities.where(:created_at => date - 7.days..date).count

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
      :activity_description => "add photo"
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
      :activity_description => "modify event"
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

  def self.in_range_for_user_counted_by_day_and_description(user=nil, start_date=7.days.ago.beginning_of_day, end_date=Time.now.beginning_of_day)
    start_date = start_date.strftime("%Y-%m-%d")
    end_date = end_date.strftime("%Y-%m-%d")
    sql = "SELECT activity_updated_time::timestamp::date AS date, 
            COUNT(CASE WHEN activity_description = 'status update' THEN 1 ELSE NULL END) AS status_update, 
            COUNT(CASE WHEN activity_description = 'add album' THEN 1 ELSE NULL END) AS add_album, 
            COUNT(CASE WHEN activity_description = 'upload video' THEN 1 ELSE NULL END) AS upload_video, 
            COUNT(CASE WHEN activity_description = 'checkin' THEN 1 ELSE NULL END) AS checkin, 
            COUNT(CASE WHEN activity_description = 'modify event' THEN 1 ELSE NULL END) AS modify_event, 
            COUNT(CASE WHEN activity_description = 'add photo' THEN 1 ELSE NULL END) AS add_photo, 
            COUNT(CASE WHEN activity_description = 'add link' THEN 1 ELSE NULL END) AS add_link 
            FROM activities 
            WHERE user_id = #{ActiveRecord::Base.sanitize(user.id)} 
            AND activity_updated_time::timestamp::date >= #{ActiveRecord::Base.sanitize(start_date)} 
            AND activity_updated_time::timestamp::date <= #{ActiveRecord::Base.sanitize(end_date)} 
            GROUP BY date"
    result = ActiveRecord::Base.connection.execute(sql)
    stringify_hash_keys(add_missing_dates(result.to_a, start_date, end_date))
  end


private

  # expects a data structure of the format
  # [{:key => "value",...},{:key => "value",...},...]
  def self.stringify_hash_keys(results)
    # loop and convert keys to strings and replace the underscores in the keys with spaces
    results.map do |hash|
      hash.inject({}) do |new_hash, (key, value)|
        new_key = snake_case_symbol_split_into_words(key)
        new_hash[new_key] = value
        new_hash
      end
    end
  end

  def self.snake_case_symbol_split_into_words(snake)
    snake.to_s.gsub(/_/, ' ') || snake.to_s
  end

  def self.add_missing_dates(input_array, start_date, end_date)
    empty_data_structures = empty_results_for_range(start_date, end_date)
    empty_data_structures.map do |hash1|
      date = hash1['date'] #extract date from the empty data structure hash element
      elements_matching_date = input_array.select{ |hash2| hash2['date'] == date }
      elements_matching_date.length == 1 ? elements_matching_date.first : hash1
    end
  end

  def self.empty_results_for_range(start_date, end_date)
    (Date.parse(start_date)).upto(Date.parse(end_date)).map do |date|
        {'date' => date.strftime("%Y-%m-%d"), 
        'status_update' => '0',
        'add_album' => '0',
        'upload_video' => '0',
        'checkin' => '0',
        'modify_event' => '0',
        'add_photo' => '0',
        'add_link' => '0'
      }
    end
  end

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


