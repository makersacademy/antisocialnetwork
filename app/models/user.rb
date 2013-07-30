class User < ActiveRecord::Base

  has_many :payments
  has_many :activities
  belongs_to :charity

	def self.create_with_omniauth(auth)
		create! do |user|
			user.provider = auth["provider"]
			user.uid = auth["uid"]
      user.name = auth["info"]["name"]
      user.email = auth["info"]["email"]
      user.fb_access_token = auth["credentials"]["token"]
      user.fb_access_expires_at = Time.at(auth["credentials"]["expires_at"])
    end
	end

  def facebook
    @facebook ||= Koala::Facebook::API.new(fb_access_token)
    block_given? ? yield(@facebook) : @facebook
  rescue Koala::Facebook::APIError => e
    logger.info e.to_s
    nil
  end

end

#  def activities_in_range_counted_by_day_and_description(start_date=7.days.ago, end_date=Time.now.beginning_of_day)
#     start_date = start_date.strftime("%Y-%m-%d")
#     end_date = end_date.strftime("%Y-%m-%d")
#     sql = "SELECT activity_updated_time::timestamp::date AS date, COUNT(CASE WHEN activity_description = 'status update' THEN 1 ELSE NULL END) AS status_update, COUNT(CASE WHEN activity_description = 'add or modify photo' THEN 1 ELSE NULL END) AS add_or_modify_photo, COUNT(CASE WHEN activity_description = 'add album' THEN 1 ELSE NULL END) AS add_album, COUNT(CASE WHEN activity_description = 'add or modify event' THEN 1 ELSE NULL END) AS add_or_modify_event, COUNT(CASE WHEN activity_description = 'checkin' THEN 1 ELSE NULL END) AS checkin, COUNT(CASE WHEN activity_description = 'add link' THEN 1 ELSE NULL END) AS add_link, COUNT(CASE WHEN activity_description = 'add link' THEN 1 ELSE NULL END) AS upload_video FROM activities WHERE user_id = #{ActiveRecord::Base.sanitize(self.id)} AND activity_updated_time::timestamp::date >= #{ActiveRecord::Base.sanitize(start_date)} AND activity_updated_time::timestamp::date <= #{ActiveRecord::Base.sanitize(end_date)} GROUP BY date"
#     Acti

# [{"date"=>"2013-07-29", "status_update"=>"7", "add_or_modify_photo"=>"2", "add_album"=>"1", "add_or_modify_event"=>"1", "checkin"=>"1", "add_link"=>"3", "upload_video"=>"3"}, {"date"=>"2013-07-28", "status_update"=>"2", "add_or_modify_photo"=>"0", "add_album"=>"0", "add_or_modify_event"=>"0", "checkin"=>"0", "add_link"=>"1", "upload_video"=>"1"}]

# status update
# add or modify photo
# add album
# add or modify event
# checkin
# add link
# upload video

# status_update
# add_or_modify_photo
# add_album
# add_or_modify_event
# checkin
# add_link
# upload_video

# sql = "SELECT activity_updated_time::timestamp::date AS date,
#  COUNT(CASE WHEN activity_description = 'status update' THEN 1 ELSE NULL END) AS status_update,
#  COUNT(CASE WHEN activity_description = 'add or modify photo' THEN 1 ELSE NULL END) AS add_or_modify_photo
#  COUNT(CASE WHEN activity_description = 'add album' THEN 1 ELSE NULL END) AS add_album
#  COUNT(CASE WHEN activity_description = 'add or modify event' THEN 1 ELSE NULL END) AS add_or_modify_event
#  COUNT(CASE WHEN activity_description = 'checkin' THEN 1 ELSE NULL END) AS checkin
#  COUNT(CASE WHEN activity_description = 'add link' THEN 1 ELSE NULL END) AS add_link
#  COUNT(CASE WHEN activity_description = 'add link' THEN 1 ELSE NULL END) AS upload_video
#  FROM activities WHERE user_id = #{ActiveRecord::Base.sanitize(user.id)}
#   GROUP BY date"

# ActiveRecord::Base.connection.execute(sql).to_json

# "SELECT activity_updated_time::timestamp::date AS date, COUNT(CASE WHEN activity_description = 'status update' THEN 1 ELSE NULL END) AS status_update, COUNT(CASE WHEN activity_description = 'add or modify photo' THEN 1 ELSE NULL END) AS add_or_modify_photo, COUNT(CASE WHEN activity_description = 'add album' THEN 1 ELSE NULL END) AS add_album, COUNT(CASE WHEN activity_description = 'add or modify event' THEN 1 ELSE NULL END) AS add_or_modify_event, COUNT(CASE WHEN activity_description = 'checkin' THEN 1 ELSE NULL END) AS checkin, COUNT(CASE WHEN activity_description = 'add link' THEN 1 ELSE NULL END) AS add_link, COUNT(CASE WHEN activity_description = 'add link' THEN 1 ELSE NULL END) AS upload_video FROM activities WHERE user_id = 1 AND activity_updated_time::timestamp::date > '2013-07-28' AND activity_updated_time::timestamp::date <= '2013-07-29' GROUP BY date"

# arr = [
#   {:description=>"a", :day=>1}, 
#   {:description=>"a", :day=>1}, 
#   {:description=>"a", :day=>2}, 
#   {:description=>"b", :day=>1},
#   {:description=>"b", :day=>2},
#   {:description=>"b", :day=>2}
# ]

# result =  [
#   {:day => 1, "a" => 2, "b" => 1}
#   {:day => 2, "a" => 1, "b" => 2}
# ]

# {:day => 30, ''}


# SELECT activity_updated_time::timestamp::date AS date,          status_update_count,
#             photo_upload_count
# FROM activities
# GROUP BY date
