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


  def activity_in_this_payment_cycle
    Time.now - ((Date.parse('2013-07-30').wday - 5) % 7)
    self.activities.group(:activity_description).where(:created_at => ((Date.parse('2013-07-31').wday - 5) % 7).days.ago..Time.now).count
  end

end
