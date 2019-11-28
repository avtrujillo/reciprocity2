class MoveFromDeviseToSorcery < ActiveRecord::Migration[5.2]
  # Sorcery stores password hashes and salts separately, while devise concatenates them together
  # In addition to updating the schema,
  # this migration ensures that current user passwords are not invalidated during the transition

  def up
    add_column :users, :reset_password_token_expires_at, :datetime

    add_column :users, :crypted_password, :string
    add_column :users, :salt, :string

    save_passwords_up

    remove_column :users, :encrypted_password, :string
  end

  def down
    add_column :users, :encrypted_password, :string
    concat_encrypted_password

    remove_column :users, :crypted_password
    remove_column :users, :salt

    remove_column :users, :reset_password_token_expires_at
  end

  private

  def save_passwords_up
    User.all.each do |user|
      raw_pw_hash = BCrypt::Password.new(user.encrypted_password)
      user.update!(salt: raw_pw_hash.salt, crypted_password: raw_pw_hash.checksum)
    end
  end

  def save_passwords_down
    User.all.each do |user|
      user.update!(encrypted_password: (user.salt + user.crypted_password))
    end

  end

  # https://www.freecodecamp.org/news/how-does-devise-keep-your-passwords-safe-d367f6e816eb/

  def split_encrypted_password
    add_column :users, :crypted_password, :string
    add_column :users, :salt, :string

    User.all.each do |user|
      user.update_columns(
              salt: user.encrypted_password[0..28],
              crypted_password: user.encrypted_password[29..-1]
      )
    end

    remove_column :users, :encrypted_password, :string
  end

  def concat_encrypted_password
    add_column :users, :crypted_password, :string

    User.all.each do |user|
      user.update_columns(encrypted_password: (user.salt + user.crypted_password))
    end

    remove_column :users, :salt, :string
    remove_column :users, :encrypted_password, :string
  end

end
