class OAuthIdentity < ApplicationRecord
  # https://github.com/omniauth/omniauth/wiki/Auth-Hash-Schema
  has_one :o_auth_credentials
  has_one :o_auth_info
end
