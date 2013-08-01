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

  def chargeable_activity_in_payment_period(period=nil)
    c_period = period || (((DateTime.now.wday - 5) % 7).days.ago.beginning_of_day..DateTime.now)
    c_period = self.created_at..DateTime.now if c_period.cover? self.created_at
    activity_in_payment_period(c_period)
  end

  def activity_in_payment_period(period=nil)
    c_period = period || (((DateTime.now.wday - 5) % 7).days.ago.beginning_of_day..DateTime.now)
    list = self.activities.group(:activity_description).where(:activity_updated_time => c_period).count
    Hash[list.sort_by { |k,v| -v }]
  end


end
