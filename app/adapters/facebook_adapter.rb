class FacebookAdapter

  attr_reader :fbgraph

  def initialize(token)
    @token ||= token
    @fbgraph = Koala::Facebook::API.new(@token)
  end

  def get_me
    get_object('me')
  end

  def get_object(id, args = {}, options = {}, &block)
    fbgraph.get_object(id, args, options, &block)
  end

  def get_connections(id, connection_name, args = {}, options = {}, &block)
    fbgraph.get_connections(id, connection_name, args, options, &block)
  end

  def appsecret_proof
   # The app secret proof is a sha256 hash of your access token, using the app secret as the key
   # https://developers.facebook.com/docs/graph-api/securing-requests
   # remember to add this to the query string of all facebook api calls as appsecret_proof
   digest = OpenSSL::Digest::SHA256.new
   key = ENV['FB_APP_SECRET']
   OpenSSL::HMAC.hexdigest(digest, key, @token)
  end

end