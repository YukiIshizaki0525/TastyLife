require 'rails_helper'

RSpec.describe Recipe, type: :model do
  let(:user) { create(:user) }
  let(:recipe) { build(:recipe, user_id: user.id) }

  it "材料・分量が紐づいていること" do
    is_expected.to have_many(:ingredients)
  end

  it "作り方が紐づいていること" do
    is_expected.to have_many(:steps)
  end

  describe "正常入力している場合は投稿可能" do
    it "正しく投稿できること" do
      ingredient = Ingredient.new(content: "材料1", quantity: "分量1")
      step = Step.new(direction: "ステップ1")

      # recipe.ingredients << ingredient
      # recipe.steps << step

      recipe.image = fixture_file_upload("no_image.png")
      recipe.save

      expect(recipe.title).to eq('テストタイトル')
      expect(recipe.description).to eq('テストディスクリプション')
      expect{recipe.ingredients << ingredient}.to change{recipe.ingredients.to_a}.from([]).to([ingredient])
      expect{recipe.steps << step}.to change{recipe.steps.to_a}.from([]).to([step])

      expect(recipe).to be_valid
    end
  end

  describe "入力に誤りがある場合は投稿不可" do
    context "必須入力であること" do
      it "レシピのタイトルは必須であること" do
        recipe = build(:recipe, title: nil)
        expect(recipe).not_to be_valid
        expect(recipe.errors[:title]).to include("を入力してください")
      end

      it "レシピの説明は必須であること" do
        recipe = build(:recipe, description: nil)
        expect(recipe).not_to be_valid
        expect(recipe.errors[:description]).to include("を入力してください")
      end
    end

    context "未記入の状態で登録できない" do
      it "材料・分量が未記入" do
        ingredient = Ingredient.new(content: nil, quantity: nil)
        recipe.ingredients << ingredient
        recipe.save

        recipe.valid? #=> valid?メソッドと使わないとエラーメッセージ取得不可
        expect(recipe.errors.full_messages.first).to eq("材料名を入力してください")
        expect(recipe.errors.full_messages.second).to eq("分量を入力してください")
      end

      it "作り方が未記入" do
        step = Step.new(direction: nil)
        recipe.steps << step
        recipe.save

        recipe.valid?
        expect(recipe.errors.full_messages.first).to eq("手順を入力してください")
      end
    end
  end
end