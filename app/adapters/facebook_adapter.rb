# require_relative 'facebook/koala_adapter.rb'
# require_relative 'facebook/facebook_token_adapter.rb'
#
# class FacebookAdapter
#   include FacebookTokenAdapter
#   include KoalaAdapter
#
#   def appsecret_proof
#     # The app secret proof is a sha256 hash of your access token, using the app secret as the key
#     # https://developers.facebook.com/docs/graph-api/securing-requests
#     # remember to add this to the query string of all facebook api calls as appsecret_proof
#     digest = OpenSSL::Digest::SHA256.new
#     key = ENV['FB_APP_SECRET']
#     OpenSSL::HMAC.hexdigest(digest, key, @token)
#   end
#
# end