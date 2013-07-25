Rails.application.config.middleware.use OmniAuth::Builder do
	provider :facebook, ENV['ASN_FACEBOOK_ID'], ENV['ASN_FACEBOOK_SECRET'],
      scope: "email, user_status"
end