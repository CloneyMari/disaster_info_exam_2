# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
10.times do
    user = User.create!(email: Faker::Internet.email, password: 'qwer4321', password_confirmation: "qwer4321")
    puts "create user id: #{user.id}, email: #{user.email}"
  end

25.times do |i|
    puts "start create #{i} post"
    region = Address::Region.all.sample
    province = region.provinces.all.sample
    city = province.cities.sample
    barangay = city.barangays.sample
    post = Post.create(title: Faker::Lorem.sentence, content: Faker::Lorem.paragraph, user: User.all.sample, categories: Category.all.sample(1), address: Faker::Address.full_address, region: region, province: province, city: city, barangay: barangay)
    puts post.errors.full_messages
    (1..20).to_a.sample.times do
      Comment.create(content: Faker::Lorem.sentence, user: User.all.sample, post: post)
    end
    puts "finish #{i} post"
    post = Post.create(title: Faker::Lorem.sentence, content: Faker::Lorem.paragraph, user: User.all.sample, address: Faker::Address.full_address)
  end
