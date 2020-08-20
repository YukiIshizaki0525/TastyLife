require "open-uri"
require 'openssl'

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

puts 'Start inserting seed "users" ...'

10.times do |n|
  password = Faker::Internet.password(min_length: 10)

  user = User.new({
    name: Faker::Internet.unique.user_name,
    email: Faker::Internet.unique.email,
    password: password,
    password_confirmation: password
  })

  user.avatar.attach(io: File.open("db/fixtures/icon#{n}.jpg"), filename: "icon#{n}.jpg")

  user.skip_confirmation!
  user.save

  puts "\"#{user.name}\" has created!"

  user.confirm
end