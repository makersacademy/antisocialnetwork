OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

Rails.application.config.middleware.use OmniAuth::Builder do
	provider :facebook, ENV['ASN_FACEBOOK_ID'], ENV['ASN_FACEBOOK_SECRET'],
      scope: "email, user_status, user_photos, user_events, read_stream, read_mailbox, user_videos"
end