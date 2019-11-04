# Rails.application.config.sorcery.submodules = [:user_activation, :http_basic_auth, :remember_me, :reset_password, :session_timeout, :brute_force_protection, :activity_logging, :external]

Rails.application.config.sorcery.configure do |config|
  config.submodules = [:reset_password, :remember_me]
  # config.session_timeout = 10.minutes

  #config.controller_to_realm_map = { 'application' => 'Application', 'users' => 'Users' }

=begin
  config.external_providers = [:tumblr, :facebook]



  config.external_providers.each do |provider|
    config.call(provider).key ||= ENV["#{provider}_APP_ID"]
    config.call(provider).secret ||= ENV["#{provider}_APP_SECRET"]
    config.call(provider).callback_url ||= "#{ENV['ROOT_URL']}oauth/callback?provider=#{provider}"

  end
  config.twitter.user_info_mapping = { email: 'screen_name' }
  config.facebook.user_info_mapping = { email: 'name' }
=end

  config.user_config do |user|
    user.username_attribute_names = [:email]

    user.reset_password_email_sent_at_attribute_name = 'reset_password_sent_at'
    user.reset_password_mailer = UserMailer
    user.reset_password_email_method_name = :reset_password_email
=begin
    user.subclasses_inherit_config                    = true

    user.user_activation_mailer                       = UserMailer
    user.activation_token_attribute_name              = :activation_code
    user.activation_token_expires_at_attribute_name   = :activation_code_expires_at

    user.reset_password_mailer                        = UserMailer
    user.reset_password_expiration_period             = 10.minutes
    user.reset_password_time_between_emails           = nil

    user.activity_timeout                             = 1.minutes

    user.consecutive_login_retries_amount_limit       = 10
    user.login_lock_time_period                       = 2.minutes

    user.authentications_class                        = UserProvider
=end
  end

  config.user_class = User
end
