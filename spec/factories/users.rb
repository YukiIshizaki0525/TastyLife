# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  confirmation_sent_at   :datetime
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string(255)
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  failed_attempts        :integer          default(0), not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string(255)
#  locked_at              :datetime
#  name                   :string(255)
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  sign_in_count          :integer          default(0), not null
#  unconfirmed_email      :string(255)
#  unlock_token           :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_name                  (name) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#

FactoryBot.define do
  # spec/support/shared_context.rbに他人を30人DB保存できるコードあり

  # factory :user, class: User do
  #   name { "alice" }
  #   sequence(:email) { |n| "test#{n}@example.com" }
  #   password { "v4xqUvAXhK" }
  #   password_confirmation { "v4xqUvAXhK" }
  #   confirmed_at { Date.today }
  # end

  # factory :other_user, class: User do
  #   name { "bob" }
  #   email { "bobtester@example.com" }
  #   password { "C2e6aNEY" }
  #   password_confirmation { "C2e6aNEY" }
  #   confirmed_at { Date.today }
  # end
  factory :user do
    name {"Alice"}
    sequence(:email) { |n| "test#{n}@example.com" }
    # email { "alicetester@example.com"}
    password {"v4xqUvAXhK"}
    password_confirmation {"v4xqUvAXhK"}
    confirmed_at { Time.zone.now }

    after(:build) do |user|
      user.avatar.attach(io: File.open('spec/fixtures/avatar.jpg'), filename: 'avatar.jpg', content_type: 'image/jpg')
    end

  # 他人
    factory :other_user do
      name { Faker::Internet.username }
      email { Faker::Internet.email }
      password { "C2e6aNEY" }
      password_confirmation { "C2e6aNEY" }
      confirmed_at { Date.today }

      #プロフィール画像を設定
      after(:build) do |other_user|
        other_user.avatar.attach(io: File.open('spec/fixtures/other_user_avatar.jpg'), filename: 'other_user_avatar.jpg', content_type: 'image/jpg')
      end
    end
  end
end
