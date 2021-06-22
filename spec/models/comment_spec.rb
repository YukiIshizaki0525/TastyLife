# == Schema Information
#
# Table name: comments
#
#  id            :bigint           not null, primary key
#  comments      :integer
#  content       :text(65535)      not null
#  reply_comment :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  recipe_id     :bigint           not null
#  user_id       :bigint           not null
#
# Indexes
#
#  index_comments_on_recipe_id  (recipe_id)
#  index_comments_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (recipe_id => recipes.id)
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }
  let(:recipe) { create(:recipe, :with_ingredients, :with_steps, user_id: other_user.id) }
  let(:comment) { build(:comment, recipe_id: recipe.id, user_id: user.id) }

  describe "正常系" do
    it '正しくコメント投稿できること' do
      comment.valid?
      expect(comment.content).to eq('レシピに対するコメントです。')
    end
  end

  describe "異常系" do
    context "未入力だとコメント投稿不可" do
      it '未入力の場合、コメント投稿ができない' do
        comment = build(:comment, content: nil)
        comment.valid?

        expect(comment.errors[:content]).to include("を入力してください")
      end
    end

    context "文字数制限" do
      it "コメントは100文字以内であること" do
        comment = build(:comment, content: "a" * 101)
        comment.valid?

        expect(comment.errors[:content]).to include("は100文字以内で入力してください")
      end
    end
  end
end
