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
FactoryBot.define do
  factory :consultation do
    title { "相談タイトル" }
    content { "相談内容" }
  end
end
