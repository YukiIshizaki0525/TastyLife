# == Schema Information
#
# Table name: relationships
#
#  id          :bigint           not null, primary key
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  followed_id :integer
#  follower_id :integer
#
# Indexes
#
#  index_relationships_on_followed_id                  (followed_id)
#  index_relationships_on_follower_id                  (follower_id)
#  index_relationships_on_follower_id_and_followed_id  (follower_id,followed_id) UNIQUE
#
require 'rails_helper'

RSpec.describe Relationship, type: :model do
  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }
  let(:active) { user.active_relationships.build(followed_id: other_user.id) }
  let(:users) { create_list(:other_user, 30) }
  subject { active }

  describe "follow/followedメソッドについて" do
    it { should respond_to(:follower) }
    it { should respond_to(:followed) }
    
    it "フォロワーを返すメソッドが有効であること" do
      expect(active.follower). to eq user
    end

    it "フォローしているユーザーを返すメソッドが有効であること" do
      expect(active.followed). to eq other_user
    end
  end

  describe "バリデーション適用確認" do
    it { is_expected.to validate_presence_of :followed_id }
    it { is_expected.to validate_presence_of :follower_id }
  end
end
