class OAuthIdentity < ApplicationRecord
  # https://github.com/omniauth/omniauth/wiki/Auth-Hash-Schema
  belongs_to :user, optional: false

  def self.create_from_auth_hash(auth_hash)
    new_from_auth_hash(auth_hash).save
  end

  def self.create_from_auth_hash!(auth_hash)
    new_from_auth_hash(auth_hash).save!
  end

  def self.new_from_auth_hash(auth_hash)
    self.new(uid: auth_hash[:uid], extra: auth_hash[:extra]).tap do |auth_ident|
      auth_ident.build_o_auth_credentials(auth_hash[:credentials])
      auth_ident.build_o_auth_info(auth_hash[:info])
    end
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

  def self.valid_provider?(provider_name)
    provider_names.map(&:downcase).include?(provider_name.to_s.downcase)
  end

end
