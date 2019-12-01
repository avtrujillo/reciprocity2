class MoveFromDeviseToSorcery < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :encrypted_password, :crypted_password
  end
end