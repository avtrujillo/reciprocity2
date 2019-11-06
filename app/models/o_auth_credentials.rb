class OAuthCredentials < ApplicationRecord
  belongs_to :o_auth_identity
  # https://github.com/omniauth/omniauth/wiki/Auth-Hash-Schema
end
