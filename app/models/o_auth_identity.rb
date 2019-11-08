class OAuthIdentity < ApplicationRecord
  # https://github.com/omniauth/omniauth/wiki/Auth-Hash-Schema
  has_one :o_auth_credentials
  has_one :o_auth_info

  def self.create_from_auth_hash(auth_hash)
    new_from_auth_hash(auth_hash).save
  end

  def self.create_from_auth_hash!(auth_hash)
    new_from_auth_hash(auth_hash).save!
  end

  def self.new_from_auth_hash(auth_hash)
    # TODO
  end

  def self.provider
    klass_string = self.to_s
    if klass_string[-8..-1] == "Identity"
      klass_string[0..-9].downcase.to_sym
    else
      nil
    end
  end

  def self.get_provider_subclass(provider)
    const_string = provider.to_s.capitalize + 'Identity'
    klass = const_get(const_string)
    if klass.is_a?(Class) && (klass < OAuthIdentity)
      klass
    else
      raise UnsupportedProviderError
    end
  end

  def self.provider_names
    OmniAuth.strategies.each_with_object(Array.new) do |strategy, acc|
      basename = strategy.to_s[22..-1]
      acc << basename unless ['OAuth', 'OAuth2'].include?(basename)
    end
  end

end
