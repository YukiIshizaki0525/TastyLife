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

  has_many :interests, dependent: :destroy

  validates :title, presence: true, length: { maximum: 50 }
  validates :content, presence: true, length: { maximum: 200 }

  ransacker :interests_count do
    query = '(SELECT COUNT(interests.consultation_id) FROM interests where interests.consultation_id = consultations.id GROUP BY interests.consultation_id)'
    Arel.sql(query)
  end

  ransacker :consultation_comments_count do
    query = '(SELECT COUNT(consultation_comments.consultation_id) FROM consultation_comments where consultation_comments.consultation_id = consultations.id GROUP BY consultation_comments.consultation_id)'
    Arel.sql(query)
  end

end
