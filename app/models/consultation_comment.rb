# == Schema Information
#
# Table name: consultation_comments
#
#  id              :bigint           not null, primary key
#  content         :text(65535)
#  reply_comment   :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  consultation_id :bigint           not null
#  user_id         :bigint           not null
#
# Indexes
#
#  index_consultation_comments_on_consultation_id  (consultation_id)
#  index_consultation_comments_on_user_id          (user_id)
#
class ConsultationComment < ApplicationRecord
  belongs_to :user
  belongs_to :consultation
  has_many :replies, class_name: :ConsultationComment, foreign_key: :reply_comment, dependent: :destroy

  validates :content, presence: true, length: { maximum: 100 }
end
