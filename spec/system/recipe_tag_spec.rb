
require 'rails_helper'

RSpec.describe "レシピタグ付け機能", type: :system, js: true do
  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }
  let(:recipe) { build(:recipe) }
  let(:other_recipe) { create(:other_recipe, :with_ingredients, :with_steps, user_id: other_user.id) }
  let(:posted_recipe) { create(:recipe, :with_ingredients, :with_steps, user_id: user.id) }
  let!(:tag) {
    create(:tag, :nourishing)
    create(:tag, :easy)
    create(:tag, :time_saving)
    create(:tag, :cost_performance)
    create(:tag, :longevity)
    create(:tag, :hospitality)
  }

  before do
    sign_in user #=> サインイン状態になる
  end

  describe 'タグ付け機能について' do
    it 'タグ付けして投稿' do
      visit new_recipe_path
      attach_file "recipe[image]", "#{Rails.root}/spec/fixtures/salad.jpg", make_visible: true
      fill_in 'recipe_title', with: recipe.title
      fill_in 'recipe_description', with: recipe.description
      click_link "材料の追加"
      find(".ingredient__content").set("材料1")
      find(".ingredient__quantity").set("分量1")

      check '栄養満点'
      click_link "作り方の追加"
      find(".step__input").set("ステップ1")

      expect { click_button '送信する' }.to change { Recipe.count }.by(1)
      expect(page).to have_content("「テストタイトル」のレシピを投稿しました。")
      expect(page).to have_selector("img[src$='salad.jpg']")
      expect(page).to have_content("材料1")
      expect(page).to have_content("分量1")
      expect(page).to have_content("栄養満点")
      expect(page).to have_content("ステップ1")
    end
  end

  describe 'タグ絞り込み機能' do
    it '絞り込みしていない時は「タグで絞り込み」と表示され、全件取得' do
      posted_recipe
      other_recipe
      visit recipes_path
      expect(page).to have_content "タグで絞り込み"
      expect(page).to have_content recipe.title
      expect(page).to have_content other_recipe.title
    end

    it '「栄養満点」のタグで絞り込み' do
      other_recipe
      visit new_recipe_path
      fill_in 'recipe_title', with: other_recipe.title
      fill_in 'recipe_description', with: other_recipe.description
      click_link "材料の追加"
      find(".ingredient__content").set("材料1")
      find(".ingredient__quantity").set("分量1")

      check '栄養満点'
      click_link "作り方の追加"
      find(".step__input").set("ステップ1")
      click_button '送信する'
      visit recipes_path
      select '栄養満点', from: 'tag_id'
      expect(page).to have_content "栄養満点"
      expect(page).to have_content recipe.title
    end

    it '「簡単」のタグで絞り込み' do
      other_recipe
      visit new_recipe_path
      fill_in 'recipe_title', with: other_recipe.title
      fill_in 'recipe_description', with: other_recipe.description
      click_link "材料の追加"
      find(".ingredient__content").set("材料1")
      find(".ingredient__quantity").set("分量1")

      check '簡単'
      click_link "作り方の追加"
      find(".step__input").set("ステップ1")
      click_button '送信する'
      visit recipes_path
      select '簡単', from: 'tag_id'
      expect(page).to have_content "簡単"
      expect(page).to have_content recipe.title
    end

    it '「時短」のタグで絞り込み' do
      other_recipe
      visit new_recipe_path
      fill_in 'recipe_title', with: other_recipe.title
      fill_in 'recipe_description', with: other_recipe.description
      click_link "材料の追加"
      find(".ingredient__content").set("材料1")
      find(".ingredient__quantity").set("分量1")

      check '時短'
      click_link "作り方の追加"
      find(".step__input").set("ステップ1")
      click_button '送信する'
      visit recipes_path
      select '時短', from: 'tag_id'
      expect(page).to have_content "時短"
      expect(page).to have_content recipe.title
    end

    it '「コスパ◎」のタグで絞り込み' do
      other_recipe
      visit new_recipe_path
      fill_in 'recipe_title', with: other_recipe.title
      fill_in 'recipe_description', with: other_recipe.description
      click_link "材料の追加"
      find(".ingredient__content").set("材料1")
      find(".ingredient__quantity").set("分量1")

      check 'コスパ◎'
      click_link "作り方の追加"
      find(".step__input").set("ステップ1")
      click_button '送信する'
      visit recipes_path
      select 'コスパ◎', from: 'tag_id'
      expect(page).to have_content "コスパ◎"
      expect(page).to have_content recipe.title
    end

    it '「日持ち◎」のタグで絞り込み' do
      other_recipe
      visit new_recipe_path
      fill_in 'recipe_title', with: other_recipe.title
      fill_in 'recipe_description', with: other_recipe.description
      click_link "材料の追加"
      find(".ingredient__content").set("材料1")
      find(".ingredient__quantity").set("分量1")

      check '日持ち'
      click_link "作り方の追加"
      find(".step__input").set("ステップ1")
      click_button '送信する'
      visit recipes_path
      select '日持ち', from: 'tag_id'
      expect(page).to have_content "日持ち"
      expect(page).to have_content recipe.title
    end

    it '「おもてなし」のタグで絞り込み' do
      other_recipe
      visit new_recipe_path
      fill_in 'recipe_title', with: other_recipe.title
      fill_in 'recipe_description', with: other_recipe.description
      click_link "材料の追加"
      find(".ingredient__content").set("材料1")
      find(".ingredient__quantity").set("分量1")

      check 'おもてなし'
      click_link "作り方の追加"
      find(".step__input").set("ステップ1")
      click_button '送信する'
      visit recipes_path
      select 'おもてなし', from: 'tag_id'
      expect(page).to have_content "おもてなし"
      expect(page).to have_content recipe.title
    end
  end
end