Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook,
           (ENV['TEST_FB_APP_ID'] || ENV['FB_APP_ID']),
           callback_url: "#{ENV['ROOT_URL']}users/auth/facebook/callback"
  # TODO: add other providers

  on_failure {|env| OmniauthCallbacksController.action(:failure).call(env)}
end