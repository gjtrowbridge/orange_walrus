namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    User.create!(display_name: "Example User",
        email: "example@railstutorial.org",
        password: "foobar",
        password_confirmation: "foobar")
    99.times do |n|
      display_name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
      User.create!(display_name: display_name,
          email: email,
          password: password,
          password_confirmation: password)
    end
  end
end