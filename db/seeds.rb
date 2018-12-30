User.create!(name:  "Example User",
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true,
             activated: true,
             activated_at: Time.zone.now,
             department:"Sales department",
             fixed_work_time: "2000-01-01 10:45:00",
             basic_work_time: "2000-01-01 10:45:00")

10.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               activated: true,
              activated_at: Time.zone.now,
              fixed_work_time: "2000-01-01 10:45:00",
              basic_work_time: "2000-01-01 10:45:00")
end

#users = User.order(:created_at).take(6)    #勤怠Bに不要
#10.times do
  #content = Faker::Lorem.sentence(5)
  #users.each { |user| user.microposts.create!(content: content) }
#end

# リレーションシップ
users = User.all
user  = users.first
#following = users[2..50]                             #勤怠Bに不要
#followers = users[3..40]                             #勤怠Bに不要
#following.each { |followed| user.follow(followed) }  #勤怠Bに不要
#followers.each { |follower| follower.follow(user) }  #勤怠Bに不要