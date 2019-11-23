class CreateOAuthIdentities < ActiveRecord::Migration[5.2]
  # https://github.com/omniauth/omniauth/wiki/Auth-Hash-Schema
  def change
    create_table :o_auth_identities do |t|

      t.integer :user_id
      t.string :uid, null: false
      t.text :extra
      t.string :type, null: false
      # provider will always be the same for each instance of a given subclass of OAuthIdentity
      # so there's no need to store it in the database

      t.string :token
      t.string :secret
      t.boolean :expires
      t.datetime :expires_at

      t.string :name
      t.string :email
      t.string :nickname
      t.string :first_name
      t.string :last_name
      t.string :location
      t.string :description
      t.string :image
      t.integer :phone
      t.text :urls

      t.timestamps
      t.index [:type, :uid], unique: true
      t.index :name
    end
  end
end
