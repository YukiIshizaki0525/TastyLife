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

  describe "正常系" do
    it "正しく投稿できること" do
      recipe.image = fixture_file_upload("salad.jpg")
      ingredient = Ingredient.new(content: "材料1", quantity: "分量1")
      step = Step.new(direction: "ステップ1")
      recipe.save

      expect(recipe.title).to eq('テストタイトル')
      expect(recipe.description).to eq('テストディスクリプション')
      expect{recipe.ingredients << ingredient}.to change{recipe.ingredients.to_a}.from([]).to([ingredient])
      expect{recipe.steps << step}.to change{recipe.steps.to_a}.from([]).to([step])

      expect(recipe).to be_valid

    end
  end
  
  describe "異常系" do
    context "必須入力であること" do
      it "レシピのタイトルは必須であること" do
        recipe = build(:recipe, title: nil)
        recipe.valid?
        expect(recipe.errors[:title]).to include("を入力してください")
      end

      it "レシピの説明は必須であること" do
        recipe = build(:recipe, description: nil)
        recipe.valid?
        expect(recipe.errors[:description]).to include("を入力してください")
      end

      it "材料と作り方は必須であること" do
        recipe.save
        recipe.valid?
        expect(recipe.errors.full_messages.first).to eq("材料は1つ以上登録してください。")
        expect(recipe.errors.full_messages.second).to eq("作り方は1つ以上登録してください。")
      end
    end

    context "未記入の状態だと登録不可" do
      it "材料・分量が未記入だと登録不可" do
        ingredient = Ingredient.new(content: nil, quantity: nil)
        recipe.ingredients << ingredient
        recipe.save

        recipe.valid? #=> valid?メソッドと使わないとエラーメッセージ取得不可
        expect(recipe.errors.full_messages.first).to eq("材料名を入力してください")
        expect(recipe.errors.full_messages.second).to eq("分量を入力してください")
      end

      it "作り方が未記入だと登録不可" do
        step = Step.new(direction: nil)
        recipe.steps << step
        recipe.save

        recipe.valid?
        expect(recipe.errors.full_messages.first).to eq("手順を入力してください")
      end
    end

    context "文字数制限" do
      it "レシピのタイトルは50文字以内であること" do
        recipe = build(:recipe, title: "a" * 51)
        recipe.save
        recipe.valid?

        expect(recipe.errors[:title]).to include("は50文字以内で入力してください")
      end

      it "レシピの説明は140文字以内であること" do
        recipe = build(:recipe, description: "a" * 141)
        recipe.save
        recipe.valid?

        expect(recipe.errors[:description]).to include("は140文字以内で入力してください")
      end
    end
  end
end