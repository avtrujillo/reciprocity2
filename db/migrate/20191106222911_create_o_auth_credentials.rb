class CreateOAuthCredentials < ActiveRecord::Migration[5.2]
  # https://github.com/omniauth/omniauth/wiki/Auth-Hash-Schema
  def change
    create_table :o_auth_credentials do |t|
      t.integer :o_auth_identity_id, null: false
      t.string :token
      t.string :secret
      t.boolean :expires
      t.datetime :expires_at

      t.timestamps
      t.index :o_auth_identity_id
    end
  end
end
