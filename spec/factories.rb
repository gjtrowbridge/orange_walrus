FactoryGirl.define do
  factory :user do
    display_name     "Orange Walrus test user"
    email    "owtestuser@orangewalrus.com"
    password "foobar"
    password_confirmation "foobar"
  end
end