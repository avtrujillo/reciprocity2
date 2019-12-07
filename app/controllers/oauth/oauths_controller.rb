module Oauth
  class OauthsController < ApplicationController
    # https://github.com/Sorcery/sorcery/wiki/External
    # TODO: add ways of merging accounts
    skip_before_action :require_login

    def provider_symbol
      params[:provider] || params['provider']
    end

    def redirect_for_login
      login_at(provider_symbol)
    end

    def callback
      @oauth_ident_hash = Hash.new
      set_provider
      set_token
      set_user_info
      set_user_and_identity
      (@user && @identity) ? success : failure
    end

    def set_user_and_identity
      @user_identity_pairer = UserIdentityPairer.new(@oauth_ident_hash.dup, current_user&.id)
      @user = @user_identity_pairer.user
      @identity = @user_identity_pairer.identity
    end

    def create_or_update
      current_user_id = current_user&.id
      user_identity_pairer = UserIdentityPairer.new(request.env['omniauth.auth'], current_user_id)
      @user = user_identity_pairer.user
      @identity = user_identity_pairer.identity
      (@user && @identity) ? success : failure
    end

    private

    def success
      auto_login(@user) unless current_user
      flash.now[:success] = @user_identity_pairer.flash_success_message
      redirect_to checks_path
    end

    def failure
      flash.now[:failure] = 'external login failed'
      # TODO: improve error messages
      render 'sessions/new'
    end

    def set_provider
      @oauth_ident_hash[:provider] = provider_symbol || params[:provider] || params['provider']
      provider = sorcery_get_provider(@oauth_ident_hash[:provider])
      if @provider.nil? || @provider != provider
        @provider = provider
        @access_token = nil
        @user_hash = nil
      end
    end

    def set_token
      @access_token = @provider.process_callback(params, session)
      provider_auth_hash = @provider.auth_hash(@access_token)
      if provider_auth_hash[:expires_in] && provider_auth_hash[:expires_at].nil?
        provider_auth_hash[:expires_at] = Time.now + provider_auth_hash[:expires_in]
      end
      provider_auth_hash[:expires_in] = nil
      provider_auth_hash[:expires] = !!provider_auth_hash[:expires_at]
      @oauth_ident_hash.merge(provider_auth_hash)
    end

    def set_user_info
      user_info_response = @access_token.get(@provider.user_info_path)
      user_info = JSON.parse(user_info_response.body, symbolize_names: true)
      user_info[:uid] ||= user_info[:id]
      user_info[:id] = nil
      @oauth_ident_hash.merge!(user_info.compact)
    end

  end
end
