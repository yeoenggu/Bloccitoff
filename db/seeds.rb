# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require "faker"
require 'factory_girl'
require Rails.root.join('spec/factories/users.rb')

if Rails.env != 'production'

  # create the user
  password = "helloworld"
  user = User.new(
    name: "user1",
    email: "user1@example.com",
    password: password,
    password_confirmation: password,
  )
  user.skip_confirmation!
  user.save

  50.times do 
    Item.create!(
      name: Faker::Lorem.word,
      description: Faker::Lorem.sentence,
      user_id: user.id
    )
  end

  # Report and finish
  puts "Seed finished"
  puts "#{user.name} was created"
  puts "#{Item.count} tasks was created"

end

