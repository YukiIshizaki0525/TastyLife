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

RSpec.describe Interest, type: :model do
  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }
  let(:consultation) { create(:consultation, user_id: other_user.id) }
  let(:interest) { user.interests.create(consultation_id: consultation.id) }
  let(:destroy_interest) { user.interests.find_by(consultation_id: consultation.id).destroy }

  it "相談について「気になる」可能" do
    expect(interest.user.name).to eq "Alice"
    expect(interest.consultation.title).to eq "相談タイトル"
    expect(user.interests.count).to eq 1
  end

  it "気になる済みであれば「気になる」の解除可能" do
    expect{ interest }.to change{ Interest.count }.by(1)
    expect{ destroy_interest }.to change{ Interest.count }.by(-1)
    expect(user.interests.count).to eq 0
  end

  it "1人が1つの相談に対して、1つしか「気になる」をつけられないこと" do
    interest
    is_expected.to validate_uniqueness_of(:consultation_id).scoped_to(:user_id)
  end
end
