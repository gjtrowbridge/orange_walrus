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
    sequence(:name) { |n| "Activity #{n}" }
    sequence(:description) { |n| "Description #{n}" }
    sequence(:location) { |n| "Location #{n}" }
    sequence(:cost) { |n| "Cost #{n}" }
    user
  end

  factory :activity_link do
    sequence(:url) { |n| "www.orangwalrus.com/activities/#{n}" }
    sequence(:description) { |n| "Link to activity #{n}" }
    activity
  end

end