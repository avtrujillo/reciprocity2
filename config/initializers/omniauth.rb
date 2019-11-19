=begin

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook,
           client_id: (ENV['TEST_FB_APP_ID'] || ENV['FB_APP_ID']),
           client_secret: ENV['TEST_FB_APP_SECRET'] || ENV['FB_APP_SECRET']#, callback_url: "#{ENV['ROOT_URL']}/auth/facebook/callback"
  # TODO: add other providers

  on_failure {|env| OmniauthCallbacksController.action(:failure).call(env)}
end

=end
