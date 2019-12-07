class PrivacyGroup < ApplicationRecord
  belongs_to :owner, class_name: 'User'
  has_many :profile_items, as: :privacy_setting, dependent: :destroy
  has_many :privacy_group_members, :dependent => :destroy
  has_many :members, through: :privacy_group_members, class_name: 'User'
end
