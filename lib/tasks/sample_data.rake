namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    User.create!(display_name: "Example User",
        email: "example@railstutorial.org",
        password: "foobar",
        password_confirmation: "foobar",
        admin: true)
    99.times do |n|
      display_name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
      User.create!(display_name: display_name,
          email: email,
          password: password,
          password_confirmation: password)
    end
    users = User.all(limit: 6)
    50.times do
      name = Faker::Lorem.sentence(10)
      description = Faker::Lorem.sentence(5)
      users.each { |user| user.activities.create!(name: name, description: description) }
    end
  end
end