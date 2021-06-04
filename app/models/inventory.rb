# == Schema Information
#
# Table name: inventories
#
#  id              :bigint           not null, primary key
#  expiration_date :date             not null
#  image           :string(255)
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
class Inventory < ApplicationRecord
  belongs_to :user

  validates :name, presence: true, length: { maximum: 20 }
  validates :quantity, presence: true, length: { maximum: 10 }
  validates :expiration_date, presence: true

  def days_left
    today = Date.today
    days_left = self.expiration_date - today
    count = days_left.to_i

    if count > 0
      "あと#{count}日"
    else
      "期限切れ"
    end
  end
end
