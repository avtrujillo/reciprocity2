require_relative 'oauths_controller.rb'

module Oauth
  class FacebookController < OauthsController
    def provider_symbol
      :facebook
    end
  end
end