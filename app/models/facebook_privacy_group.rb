class FacebookPrivacyGroup < ExternalPrivacyGroup

  def populate
    members_cache = self.members
    friend_users.each do |user|
      unless members_cache.include?(user)
        PrivacyGroupMember.create(privacy_group_id: @privacy_group.id, user_id: user.id)
      end
    end
  end

  def prune
    friend_users_cache = self.friend_users
    privacy_group_members.each do |pgm|
      unless friend_users_cache.include?(pgm.member)
        pgm.destroy!
        # this destroys the PrivacyGroupMember entry, not the user
      end
    end
  end

  private

  def friend_uids
    @friend_uids ||= adapter.get_connections('me', 'friends')
  end

  def friend_identities
    @friends_list ||= friend_uids.map do |friend_uid|
      FacebookIdentity.find_by(uid: friend_uid)
    end
  end

  def friend_users
    @friend_users ||= friend_identities.map do |fb_identity|
      fb_identity.user
    end
  end

end