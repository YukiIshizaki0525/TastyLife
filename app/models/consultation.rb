# == Schema Information
#
# Table name: consultations
#
#  id                :bigint           not null, primary key
#  content           :text(65535)
#  impressions_count :integer          default(0)
#  title             :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  user_id           :bigint           not null
#
# Indexes
#
#  index_consultations_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Consultation < ApplicationRecord
  belongs_to :user
  has_many :consultation_comments, dependent: :destroy

  # 閲覧数カウント
  is_impressionable counter_cache: true

  validates :title, presence: true, length: { maximum: 50 }
  validates :content, presence: true, length: { maximum: 200 }
end
