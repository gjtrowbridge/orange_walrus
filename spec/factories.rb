FactoryGirl.define do
  factory :user do
    sequence(:display_name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
      admin true
    end
  end

  factory :activity do
    name "Activity Name"
    description "Activity description here."
    user
  end
end