class UserF < ActiveRecord::Base

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize do |userF|
      userF.provider = auth.provider
      userF.uid = auth.uid
      userF.name = auth.info.name
      userF.oauth_token = auth.credentials.token
      userF.oauth_expires_at = Time.at(auth.credentials.expires_at)
      userF.save!
    end
  end

  def facebook
    @facebook ||= Koala::Facebook::API.new(oauth_token)
  end


  def myImage
    facebook.get_picture("me")
  end

  def friends
    facebook.get_connection("me", "friends").size
  end

end

