# == Schema Information
#
# Table name: consultation_comments
#
#  id              :bigint           not null, primary key
#  content         :text(65535)      not null
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
# Foreign Keys
#
#  fk_rails_...  (consultation_id => consultations.id)
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :consultation_comment do
    content { "相談に対するコメントです。" }

    trait :reply do
      content { "コメントへの返信です。" }
    end
  end
end
