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
require 'rails_helper'

RSpec.describe ConsulationComment, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
