module ExternalConfig

  FACEBOOK_CONFIG = Proc.new do |config|
    config.facebook.user_info_mapping = {
        email: 'name'
    }
    config.facebook.key = ENV['FB_APP_ID'] || ENV['TEST_FB_APP_ID']
    config.facebook.secret = ENV['FB_APP_SECRET'] || ENV['TEST_FB_APP_SECRET']
    config.facebook.callback_url = "#{ENV['ROOT_URL']}/auth/facebook/callback"
  end

end
