class ExternalPrivacyGroup < PrivacyGroup
  # abstract class for e.g. FacebookPrivacyGroup
  # subclasses should be sure to implement :populate
  validate :must_have_identity

  def self.find_or_create_from_owner_id(owner_id)
    find_by(owner_id: owner_id) || create_from_owner_id(owner_id)
  end

  def self.create_from_owner_id(owner_id)
    new_from_owner_id(owner_id).tap(&:save!)
  end

  def self.new_from_owner_id(owner_id)
    self.new(
        owner_id: owner_id,
        name: default_pg_name
    ).tap(&:populate)
  end

  def populate
    # abstract method for importing e.g. facebook friends with an adapter
  end

  def prune
    # abstract method for removing members who are no long e.g. facebook friends
  end

  private

  def self.default_pg_name
    "#{provider_name} Friends"
  end

  def owner_identity
    @owner_identity ||= identity_class.find_by(user_id: owner.id)
  end

  def adapter
    @adapter ||= adapter_class.new(owner_identity.token)
  end

  def must_have_identity
    unless owner_identity
      errors.add(:identity, "Must have an associated #{identity_class.to_s}")
    end
  end

  def provider_name
    self.class.provider_name
  end

  def self.provider_name
    # for example, returns 'Facebook' when called on FacebookPrivacyGroup
    to_s[0...-12]
  end

  def identity_class
    self.class.identity_class
  end

  def self.identity_class
    klass = const_get(provider_name + 'Identity')
    raise 'invalid identity class' unless klass.superclass == OAuthIdentity
    klass
  end

  def self.adapter_class
    const_get(provider_name + 'Adapter')
  end

end