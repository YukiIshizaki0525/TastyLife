
require 'rails_helper'

RSpec.describe "レシピタグ付け機能", type: :system do
  let(:user) { create(:user) }
  let(:recipe) { build(:recipe) }
  let!(:tag) { create(:tag) }

  before do
    sign_in user #=> サインイン状態になる
  end

  it 'タグ付け機能' do
    visit new_recipe_path
    attach_file "recipe[recipe_image]", "#{Rails.root}/spec/fixtures/salad.jpg", make_visible: true
    fill_in 'recipe_title', with: recipe.title
    fill_in 'recipe_description', with: recipe.description
    click_link "材料の追加"
    find(".ingredient__content").set("材料1")
    find(".ingredient__quantity").set("分量1")

    check 'タグ1'
    click_link "作り方の追加"
    find(".step__input").set("ステップ1")

    expect { click_button '送信する' }.to change { Recipe.count }.by(1)
    expect(page).to have_content("「テストタイトル」のレシピを投稿しました。")
    expect(page).to have_selector("img[src$='salad.jpg']")
    expect(page).to have_content("材料1")
    expect(page).to have_content("分量1")
    expect(page).to have_content("タグ1")
    expect(page).to have_content("ステップ1")
  end
end