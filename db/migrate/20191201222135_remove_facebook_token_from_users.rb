class RemoveFacebookTokenFromUsers < ActiveRecord::Migration[5.2]

  def up
    User.all.each do |user|
      if user.facebook_token
        FacebookIdentity.create!(
                            user_id: user.id,
                            uid: user.uid,
                            token: user.facebook_token
        )
      end
      remove_columns :users, :facebook_token, :uid, :provider
    end

  end

  def down
    add_column :users, :facebook_token, :string
    add_column :users, :uid, :string
    add_column :users, :provider, :string
    User.all.each do |user|
      fb_identity = FacebookIdentity.find_by(user_id: user.id)
      if fb_identity
        User.update!(
                facebook_token: fb_identity.token,
                uid: fb_identity.uid,
                provider: 'facebook'
        )
      end
    end
  end

end
