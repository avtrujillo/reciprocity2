require_relative 'oauths_controller.rb'

module Oauth
  class TumblrController < OauthsController

    def provider_symbol
      :tumblr
    end

    def set_user_info
      @tumblr_client = client_from_access_token
      user_info = @tumblr_client.info
      user_info[:uid] ||= user_info[:id]
      user_info[:id] = nil
      @oauth_ident_hash.merge!(user_info.compact)
    end

    private

    def client_from_access_token
      Tumblr::Client.new(
          consumer_key: @access_token.consumer.key,
          consumer_secret: @access_token.consumer.secret,
          oauth_token: @access_token.token,
          oauth_token_secret: @access_token.secret
      )
    end
  end
end