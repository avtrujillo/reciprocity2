class AddTypeToPrivacyGroup < ActiveRecord::Migration[5.2]
  def change
    add_column :privacy_groups, :type, :string
  end
end
