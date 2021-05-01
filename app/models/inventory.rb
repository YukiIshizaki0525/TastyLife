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
class Inventory < ApplicationRecord
  belongs_to :user
  has_many :notifications, dependent: :destroy

  validates :name, presence: true, length: { maximum: 20 }
  validates :quantity, presence: true, length: { maximum: 10 }
  validates :expiration_date, presence: true

  has_one_attached :photo

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

  def create_notification_inventory!(current_user)
    temp = Notification.where(["visitor_id = ? and visited_id = ? and inventory_id = ?", current_user.id, user_id, id, 'inventory'])

    if temp.blank?
      notification = current_user.active_notifications.new(
        inventory_id: id,
        visited_id: user_id,
      )
      # 自分の投稿に対するいいねの場合は、通知済みとする
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end
  end
end
