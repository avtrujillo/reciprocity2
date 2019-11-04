class RefactorActivityLogging < ActiveRecord::Migration[5.2]
  # refactoring user activity tracking so it uses sorcery instead of devise
  # https://github.com/Sorcery/sorcery/blob/master/lib/sorcery/model/submodules/activity_logging.rb
  # https://www.rubydoc.info/github/plataformatec/devise/master/Devise/Models/Trackable
  def up
    change_table :users do |t|
      t.datetime :last_logout_at
      t.datetime :last_activity_at

      t.rename :last_sign_in_at, :last_login_at
      t.rename :last_sign_in_ip, :last_login_from_ip_address

      t.remove :current_sign_in_ip, :current_sign_in_at
    end
  end

  def down
    change_table :users do |t|
      t.remove :last_logout_at, :last_activity_at

      t.rename :last_sign_in_at, :last_login_at
      t.rename :last_sign_in_ip, :last_login_from_ip_address

      t.string :current_sign_in_ip
      t.string :current_sign_in_at
    end
  end

end
