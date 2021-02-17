# == Schema Information
#
# Table name: inventories
#
#  id              :bigint           not null, primary key
#  expiration_date :date             not null
#  memo            :text(65535)
#  name            :string(255)      not null
#  quantity        :string(255)      not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  user_id         :bigint           not null
#
# Indexes
#
#  index_inventories_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :inventory do
    name { "MyString" }
    quantity { 1 }
    expiration_date { "2021-02-11" }
    memo { "MyText" }
    user { nil }
  end
end
