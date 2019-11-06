FactoryBot.define do
  factory :o_auth_info do
    o_auth_identity_id { 0 }
    name { "MyString" }
    email { "MyString" }
    nickname { "MyString" }
    first_name { "MyString" }
    last_name { "MyString" }
    location { "MyString" }
    description { "MyString" }
    image { "MyString" }
    phone { 15558675309 }
    urls { "MyText" }
  end
end
