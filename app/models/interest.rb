# == Schema Information
#
# Table name: interests
#
#  id              :bigint           not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  consultation_id :bigint           not null
#  user_id         :bigint           not null
#
# Indexes
#
#  index_interests_on_consultation_id  (consultation_id)
#  index_interests_on_user_id          (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (consultation_id => consultations.id)
#  fk_rails_...  (user_id => users.id)
#
class Interest < ApplicationRecord
  belongs_to :user
  belongs_to :consultation

  validates_uniqueness_of :consultation_id, scope: :user_id
end
