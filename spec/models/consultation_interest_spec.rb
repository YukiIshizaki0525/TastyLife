# == Schema Information
#
# Table name: consultation_interests
#
#  id              :bigint           not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  consultation_id :bigint           not null
#  user_id         :bigint           not null
#
# Indexes
#
#  index_consultation_interests_on_consultation_id  (consultation_id)
#  index_consultation_interests_on_user_id          (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (consultation_id => consultations.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe ConsultationInterest, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
