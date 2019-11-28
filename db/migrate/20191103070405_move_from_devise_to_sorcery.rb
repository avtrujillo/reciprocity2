class MoveFromDeviseToSorcery < ActiveRecord::Migration[5.2]

  def up
    add_column :users, :reset_password_token_expires_at, :datetime
    split_encrypted_password
  end

  def down
    remove_column :users, :reset_password_token_expires_at
    concat_encrypted_password
  end

  private

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
