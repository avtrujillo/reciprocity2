# Rails.application.config.sorcery.submodules = [:user_activation, :http_basic_auth, :remember_me, :reset_password, :session_timeout, :brute_force_protection, :activity_logging, :external]

require_relative 'config/initializers/sorcery/external.rb'

Rails.application.config.sorcery.configure do |config|
  config.submodules = [:reset_password, :remember_me, :external]
  # config.session_timeout = 10.minutes

  #config.controller_to_realm_map = { 'application' => 'Application', 'users' => 'Users' }

  config.external_providers = [:facebook]

  config.user_config do |user|
    user.username_attribute_names = [:email]

    user.reset_password_email_sent_at_attribute_name = 'reset_password_sent_at'
    user.reset_password_mailer = UserMailer
    user.reset_password_email_method_name = :reset_password_email
    config.authentications_class = OAuthIdentity
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

  Rails.application.config.sorcery.configure(ExternalConfig::FACEBOOK_CONFIG)

  config.user_class = User
end
