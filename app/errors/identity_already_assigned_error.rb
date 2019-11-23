class IdentityAlreadyAssignedError < StandardError
  def message
    'The OAuthIdentity passed to User.create_from_oauth is already assigned to a user'
  end
end