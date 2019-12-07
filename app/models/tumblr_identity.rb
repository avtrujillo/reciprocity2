class TumblrIdentity < OAuthIdentity
  def self.new_from_auth_hash(input_hash, user_id = nil)
    @auth_hash = format_auth_hash(input_hash)
    @auth_hash[:user_id] = user_id
    new(@auth_hash)
  end

  def self.format_auth_hash(input_hash)
    info_hash = input_hash[:user].deep_symbolize_keys
    main_blog = info_hash[:blogs].find{|blog| blog[:primary]}
    {
        uid: main_blog[:uuid],
        name: main_blog[:name],
        email: main_blog[:email],
        description: main_blog[:description],
        urls: info_hash[:blogs].map{ |blog| blog[:url]},
        'type' => self.to_s
    #TODO: add image
    }
  end

end
