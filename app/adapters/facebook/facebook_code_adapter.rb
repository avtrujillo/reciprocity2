module FacebookTokenAdapter
  # exchanges an OAuth confirmation code for a token
  # https://developers.facebook.com/docs/facebook-login/manually-build-a-login-flow#confirm

  def initialize(token, expires_at = nil)
    @token = token
    @expires_at = expires_at
  end

  def self.new_from_code(fb_code)
    FacebookAdapter.new.tap do |fba|
      fba.exchange_code_for_token(fb_code)
    end
  end

  def exchange_code_for_token(fb_code = nil)
    @code = fb_code unless fb_code.nil?
    uri = token_request_uri(code_exchange_params)
    response = JSON.parse(Net::HTTP.get_response(uri).body)
    @token = response['access_token']
    @expires_at = response['expires_at'] || (Time.now + response['expires_in'])
    raise
    refresh_token_if_needed
  end

  def redirect_uri_string
    root_url = ENV['ROOT_URL'] || ENV['DOMAIN']
    slash_if_needed = (root_url[-1] == '/') ? '' : '/'
    root_url + slash_if_needed + 'auth/facebook/callback'
  end

  private

  def token_request_uri(token_params)
    uri = URI('https://graph.facebook.com/v4.0/oauth/access_token')
    uri.query = URI.encode_www_form(token_params)
    uri
  end

  def code_exchange_params
    {
        client_id: (Rails.env.production?) ? ENV['FB_APP_ID'] : ENV['TEST_FB_APP_ID'],
        client_secret: (Rails.env.production?) ? ENV['FB_APP_SECRET'] : ENV['TEST_FB_APP_SECRET'],
        code: @code,
        appsecret_proof: appsecret_proof,
        redirect_uri: URI(redirect_uri_string)
    }
  end

  def refresh_token
    uri = token_request_uri(token_refresh_params)
    response = JSON.parse(Net::HTTP.get_response(uri).body)
    new_token = response['access_token']
    if new_token
      @token = new_token
      @expires_at = response['expires_at'] || (Time.now + response['expires_in'])
      true
    else
      false
    end
  end

  def token_refresh_params
    {
        client_id: (Rails.env.production?) ? ENV['FB_APP_ID'] : ENV['TEST_FB_APP_ID'],
        client_secret: (Rails.env.production?) ? ENV['FB_APP_SECRET'] : ENV['TEST_FB_APP_SECRET'],
        appsecret_proof: appsecret_proof,
        grant_type: 'fb_exchange_token',
        fb_exchange_token: @token
    }
  end

  def refresh_token_if_needed
    # if the token will expire within 30 days, refresh it
    # https://developers.facebook.com/docs/facebook-login/access-tokens/refreshing
    time_remaining = Time.now - @expires_at
    if (time_remaining > 2592000)
      false
    else
      refresh_token
    end
  end

end