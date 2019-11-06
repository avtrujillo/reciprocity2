class CreateOAuthInfos < ActiveRecord::Migration[5.2]
  # https://github.com/omniauth/omniauth/wiki/Auth-Hash-Schema
  def change
    create_table :o_auth_infos do |t|
      t.integer :o_auth_identity_id, null: false
      t.string :name, null: false
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
    end
    add_index :o_auth_infos, :o_auth_identity_id
  end
end
