# == Schema Information
#
# Table name: comments
#
#  id            :bigint           not null, primary key
#  comment       :text(65535)      not null
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
require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }
  let(:posted_recipe) { create(:recipe, :with_ingredients, :with_steps, user_id: user.id) }
  let(:comment) { build(:comment, recipe_id: posted_recipe.id, user_id: other_user.id) }

  describe "正常系" do
    it ' 正しく登録できること' do
      comment.save
      comment.valid?

      expect(comment.comment).to eq('このコメントはテストです。')
    end
  end

  describe "異常系" do
    context "未入力だと登録不可" do
      it '未入力の場合、登録ができない' do
        comment = build(:comment, comment: nil)
        comment.valid?

        expect(comment.errors[:comment]).to include("を入力してください")
      end
    end

    context "文字数制限があること" do
      it "コメントは100文字以内であること" do
        comment = build(:comment, comment: "a" * 101)
        comment.save
        comment.valid?

        expect(comment.errors[:comment]).to include("は100文字以内で入力してください")
      end
    end
  end
end
