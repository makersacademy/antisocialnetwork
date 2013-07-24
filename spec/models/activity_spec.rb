require 'spec_helper'

describe Activity do
  let(:user) do
    FactoryGirl.create(:user,
      name: "John Smith",
      email: "doubled@gmail.com",
      provider: "facebook",
      uid: "100006352424167",
      fb_access_token: "ABCDEF...",
      fb_access_expires_at: "1321747205"
    )
  end


end
