class RefactorRememberMe < ActiveRecord::Migration[5.2]
  # Sorcery implements this feature differently from Devise

  def up
    change_table :users do |t|
      t.string :remember_me_token
      t.datetime :remember_me_token_expires_at

      t.remove :remember_created_at
    end
  end

  def down
    change_table :users do |t|
      t.remove :remember_me_token
      t.remove :remember_me_token_expires_at

      t.datetime :remember_created_at
    end
  end
end
