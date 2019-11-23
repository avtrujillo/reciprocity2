Koala.configure do |config|
  config.app_id = (ENV['TEST_FB_APP_ID'] || ENV['FB_APP_ID'])
  config.app_secret = ENV['TEST_FB_APP_SECRET'] || ENV['FB_APP_SECRET']
end
