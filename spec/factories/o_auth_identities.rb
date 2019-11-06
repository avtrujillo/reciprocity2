FactoryBot.define do
  factory :o_auth_identity do
    type { "OAuthIdentity" }
    uid { "MyString" }
    extra { "MyText" }
  end
end
