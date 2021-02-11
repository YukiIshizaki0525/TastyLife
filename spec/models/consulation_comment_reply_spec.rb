# == Schema Information
#
# Table name: consulation_comment_replies
#
#  id                     :bigint           not null, primary key
#  content                :text(65535)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  consulation_comment_id :bigint           not null
#  user_id                :bigint           not null
#
# Indexes
#
#  index_consulation_comment_replies_on_consulation_comment_id  (consulation_comment_id)
#  index_consulation_comment_replies_on_user_id                 (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (consulation_comment_id => consultation_comments.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe ConsulationCommentReply, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
