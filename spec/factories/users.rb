# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  avatar                 :string(255)
#  confirmation_sent_at   :datetime
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string(255)
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  failed_attempts        :integer          default(0), not null
#  is_deleted             :boolean          default(FALSE), not null
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
  factory :user do
    name { "Alice" }
    email { "Alice@example.com" }
    avatar { File.open("#{Rails.root}/spec/fixtures/avatar.jpg") }
    password {"v4xqUvAXhK"}
    password_confirmation {"v4xqUvAXhK"}
    confirmed_at { Date.today }

    factory :other_user do
      name { Faker::Internet.username }
      email { Faker::Internet.email }
      avatar { File.open("#{Rails.root}/spec/fixtures/other_user_avatar.jpg") }
      password { "C2e6aNEY" }
      password_confirmation { "C2e6aNEY" }
      confirmed_at { Date.today }
    end
  end
end
