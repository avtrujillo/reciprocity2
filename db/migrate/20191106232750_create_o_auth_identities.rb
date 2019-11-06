class CreateOAuthIdentities < ActiveRecord::Migration[5.2]
  # https://github.com/omniauth/omniauth/wiki/Auth-Hash-Schema
  def change
    create_table :o_auth_identities do |t|
      t.string :type, null: false
      # provider will always be the same for each instance of a given subclass of OAuthIdentity
      # so there's no need to store it in the database
      t.string :uid, null: false
      t.text :extra

      t.timestamps
    end
  end
  add_index :o_auth_identities, [:type, :uid], unique: true
end
