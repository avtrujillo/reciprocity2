class AddTypeToPrivacyGroup < ActiveRecord::Migration[5.2]
  def up
    add_column :privacy_groups, :type, :string
    add_index :privacy_groups, [:type, :owner_id], unique: :true
    PrivacyGroup.all.each do |pg|
      pg.type = pg.class.to_s
    end
  end
  def down
    remove_index :privacy_groups, [:type, :owner_id]
    remove_column :privacy_groups, :type
  end
end
