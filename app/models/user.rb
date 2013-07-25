class User < ActiveRecord::Base

  has_many :payments
  has_many :activities

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

  def get_statuses(start_time, end_time)
    facebook do |fb| 
      # fb.get_connection("me", "statuses")
      fb.fql_query("SELECT status_id, time, uid, message FROM status WHERE uid = #{self.uid} AND time > #{start_time} AND time < #{end_time}")
    end
  end

end
