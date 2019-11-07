class UserIdentityPairer
  # TODO: add logic to deal with identities with identical emails but different users
  attr_reader :user
  attr_reader :identity

  def initialize(auth_hash, current_user_id = nil)
    # the controller that created this object should log the user in after the initialize
    # method of this object has finished if the user is not already logged in
    @current_user_id = current_user_id
    @auth_hash = auth_hash
    @identity = identity_class.find_by(uid: @auth_hash[:uid])
    create_identity_if_needed # also attempts to set @current_user_id
    find_or_create_user
  end

  def identity_class
    @identity_class ||= OAuthIdentity.get_provider_subclass(@auth_hash[:provider])
  end

  def new_user?
    @new_user
  end

  def new_identity?
    @new_identity
  end

  def provider
    @auth_hash[:provider]
  end

  def flash_success_message
    if @new_user && @new_identity
      "Created new user with #{provider}"
    elsif @new_identity
      "Linked with #{provider}"
    elsif @new_user
      # not possible
    else
      "Logged in with #{provider}"
    end
  end

  private

  def create_identity_if_needed
    @new_identity = false
    if @current_user_id && @identity
      raise UserMismatchError unless @current_user_id == @identity.user_id
    elsif @identity
      # the user will be logged in by the calling controller
    else
      @new_identity = true
      @identity = identity_class.new_from_auth_hash(@auth_hash)
      @identity.user_id = @current_user_id # this could still be nil at this point
    end
    @current_user_id = @identity.user_id # this could still be nil at this point
  end

  def find_or_create_user
    @user = if @current_user_id
              @new_user = false
              User.find(@current_user_id)
            else
              @new_user = true
              @identity.email ||= create_placeholder_email unless Rails.env.production?
              User.create_from_oauth(@identity)
            end
  end

  def create_placeholder_email
    # TODO: figure out what to do when creating a new user from an auth hash that
    # does not include an email address
    "#{identity_class.to_s}_#{@auth_hash[:uid].to_s}@#{ENV['ROOT_URL']}"
  end

end