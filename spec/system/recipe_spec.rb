require 'rails_helper'

RSpec.describe "レシピ機能", type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }
  let(:recipe) { build(:recipe) }
  let(:posted_recipe) { create(:recipe, :with_ingredients, :with_steps, :with_images, user_id: user.id) }

  before do
    sign_in user #=> サインイン状態になる
  end

  describe '新規作成機能' do
    context 'フォームの入力値が正常'do
      it '正常に登録される' do
        visit new_recipe_path
        attach_file "recipe[image]", "#{Rails.root}/spec/fixtures/salad.jpg", make_visible: true
        fill_in 'recipe_title', with: recipe.title
        fill_in 'recipe_description', with: recipe.description
        click_link "材料の追加"
        find(".ingredient__content").set("材料1")
        find(".ingredient__quantity").set("分量1")
        click_link "作り方の追加"
        find(".step__input").set("ステップ1")
        attach_file "step-image", "#{Rails.root}/spec/fixtures/tomato.jpg"

        expect { click_button '送信する' }.to change { Recipe.count }.by(1)
        expect(page).to have_content("「テストタイトル」のレシピを投稿しました。")
        expect(page).to have_selector("img[src$='salad.jpg']")
        expect(page).to have_content("材料1")
        expect(page).to have_content("分量1")
        expect(page).to have_content("ステップ1")
        expect(page).to have_selector("img[src$='tomato.jpg']")
      end
    end

    context 'フォームの入力値が異常' do
      it 'レシピのタイトル・説明が入力されていないため登録不可' do
        visit new_recipe_path
        fill_in 'recipe_title', with: nil
        fill_in 'recipe_description', with: nil
        click_link "材料の追加"
        find(".ingredient__content").set("材料1")
        find(".ingredient__quantity").set("分量1")
        click_link "作り方の追加"
        find(".step__input").set("ステップ1")
        click_button '送信する'
        expect(page).to have_content("レシピのタイトルを入力してください")
        expect(page).to have_content("レシピの説明を入力してください")
      end

      it 'レシピのタイトルは50文字・説明は140文字を超える場合は登録不可' do
        visit new_recipe_path
        fill_in 'recipe_title', with:  "a" * 51
        fill_in 'recipe_description', with:  "a" * 141
        click_link "材料の追加"
        find(".ingredient__content").set("材料1")
        find(".ingredient__quantity").set("分量1")
        click_link "作り方の追加"
        find(".step__input").set("ステップ1")
        click_button '送信する'
        expect(page).to have_content("レシピのタイトルは50文字以内で入力してください")
        expect(page).to have_content("レシピの説明は140文字以内で入力してください")
      end

      it '材料と作り方はそれぞれ1つ以上入っていないと登録不可' do
        visit new_recipe_path
        fill_in 'recipe_title', with: recipe.title
        fill_in 'recipe_description', with: recipe.description
        click_button '送信する'
        expect(page).to have_content("材料は1つ以上登録してください。")
        expect(page).to have_content("作り方は1つ以上登録してください。")
      end

      it '材料・分量に値が入っていないため登録不可' do
        visit new_recipe_path
        fill_in 'recipe_title', with: recipe.title
        fill_in 'recipe_description', with: recipe.description
        click_link "材料の追加"
        find(".ingredient__content").set(nil)
        find(".ingredient__quantity").set(nil)
        click_link "作り方の追加"
        find(".step__input").set("ステップ1")
        click_button '送信する'
        expect(page).to have_content("材料名を入力してください")
        expect(page).to have_content("分量を入力してください")
      end

      it '手順に値が入っていないため登録不可' do
        visit new_recipe_path
        fill_in 'recipe_title', with: recipe.title
        fill_in 'recipe_description', with: recipe.description
        click_link "材料の追加"
        find(".ingredient__content").set("材料1")
        find(".ingredient__quantity").set("分量1")
        click_link "作り方の追加"
        find(".step__input").set(nil)
        click_button '送信する'
        expect(page).to have_content("手順を入力してください")
      end

      it 'レシピ画像及び手順画像が3MB以上の場合は登録不可' do
        visit new_recipe_path
        attach_file "recipe[image]", "#{Rails.root}/spec/fixtures/pasta_8MB.jpg", make_visible: true
        fill_in 'recipe_title', with: recipe.title
        fill_in 'recipe_description', with: recipe.description
        click_link "材料の追加"
        find(".ingredient__content").set("材料1")
        find(".ingredient__quantity").set("分量1")
        click_link "作り方の追加"
        find(".step__input").set("ステップ1")
        attach_file "step-image", "#{Rails.root}/spec/fixtures/pasta_8MB.jpg"

        click_button '送信する'
        expect(page).to have_content("レシピ画像は3MB以下のサイズにしてください")
        expect(page).to have_content("手順の画像は3MB以下のサイズにしてください")
      end
    end
  end

  describe '詳細表示機能' do
    it '誰でもレシピ詳細を閲覧可能' do
      visit recipe_path(posted_recipe)
      expect(page).to have_content(posted_recipe.title)
      expect(page).to have_content(posted_recipe.description)
      expect(page).to have_content("材料1")
      expect(page).to have_content("分量1")
      expect(page).to have_content("ステップ1")
    end
    it '他の方の相談はレシピ編集リンクが表示されない' do
      sign_in other_user
      visit recipe_path(posted_recipe)
      expect(page).to_not have_content("レシピ編集")
    end
  end

  describe '編集機能' do
    context '変更反映可能' do
      it '項目追加をした場合、正常な値入力ができていれば反映可能' do
        visit edit_recipe_path(posted_recipe)
        expect(page).to have_field 'recipe_title', with: recipe.title
        expect(page).to have_field 'recipe_description', with: recipe.description
        fill_in 'recipe_title', with: 'テストタイトル2'
        fill_in 'recipe_description', with: 'テストディスクリプション2'
        click_link "材料の追加"
        #2つ目の要素に登録
        page.all(".ingredient__content")[1].set("材料2")
        page.all(".ingredient__quantity")[1].set("分量2")
        click_link "作り方の追加"
        #2つ目の要素に登録
        page.all(".step__input") [1].set("ステップ2")
        click_button '送信する'
        expect(current_path).to eq recipe_path(posted_recipe)
        expect(page).to have_content(posted_recipe.title)
        expect(page).to have_content(posted_recipe.description)
        expect(page).to have_content("材料1")
        expect(page).to have_content("材料2")
        expect(page).to have_content("分量1")
        expect(page).to have_content("分量2")
        expect(page).to have_content("ステップ1")
        expect(page).to have_content("ステップ2")
      end
    end

    context '変更反映不可' do
      it 'レシピのタイトル・説明を未入力にしたら変更反映不可' do
        visit edit_recipe_path(posted_recipe)
        expect(page).to have_field 'recipe_title', with: recipe.title
        expect(page).to have_field 'recipe_description', with: recipe.description
        fill_in 'recipe_title', with: nil
        fill_in 'recipe_description', with: nil
        click_button '送信する'
        expect(page).to have_content("レシピのタイトルを入力してください")
        expect(page).to have_content("レシピの説明を入力してください")
      end

      it '材料・分量を未入力にしたら変更反映不可' do
        visit edit_recipe_path(posted_recipe)
        find(".ingredient__content").set(nil)
        find(".ingredient__quantity").set(nil)
        click_button '送信する'
        expect(current_path).to eq edit_recipe_path(posted_recipe)
        expect(page).to have_content("材料名を入力してください")
        expect(page).to have_content("分量を入力してください")
      end

      it '手順を未入力にしたら変更反映不可' do
        visit edit_recipe_path(posted_recipe)
        find(".step__input").set(nil)
        click_button '送信する'
        expect(current_path).to eq edit_recipe_path(posted_recipe)
        expect(page).to have_content("手順を入力してください")
      end
    end

    it '編集を中断し、詳細ページに戻ることができる' do
      visit edit_recipe_path(posted_recipe)
      click_link '編集をやめる'
      expect(current_path).to eq recipe_path(posted_recipe)
    end

    it "他の方のレシピは編集不可" do
      sign_in other_user
      visit edit_recipe_path(posted_recipe)
      expect(current_path).to eq root_path
      expect(page).to have_content("他人のレシピは編集できません")
    end
  end

  describe '削除機能' do
    it '編集ページから削除ボタンを押せばレシピの削除が可能' do
      visit edit_recipe_path(posted_recipe)
      expect(Recipe.count).to eq 1

      click_link 'レシピを削除'
      expect(page.driver.browser.switch_to.alert.text).to eq "削除してよろしいですか？"
      page.driver.browser.switch_to.alert.accept
      expect(current_path).to eq user_path(user)
      expect(Recipe.count).to eq 0
      expect(page).to have_content("「#{posted_recipe.title}」のレシピを削除しました。")

    end

    it "編集ページからレシピの画像削除が可能" do
      visit edit_recipe_path(posted_recipe)
      check 'recipe[remove_image]'
      click_button '送信する'
      expect(current_path).to eq recipe_path(posted_recipe)
      expect(page).to_not have_selector("img[src$='salad.jpg']")
    end
  end

  describe '検索機能' do
    context "レシピタイトルでの検索可能" do
      it "全一致で検索可能"do
        posted_recipe
        visit recipes_path
        fill_in "q_title_or_ingredients_content_cont", with: "テストタイトル"
        find("#q_title_or_ingredients_content_cont").send_keys :return
        expect(page).to have_content(posted_recipe.title)
        expect(page).to have_content(posted_recipe.description)
        expect(page).to have_content(posted_recipe.user.name)
      end

      it "部分一致でも可能" do
        posted_recipe
        visit recipes_path
        fill_in "q_title_or_ingredients_content_cont", with: "テスト"
        find("#q_title_or_ingredients_content_cont").send_keys :return
        expect(page).to have_content(posted_recipe.title)
        expect(page).to have_content(posted_recipe.description)
        expect(page).to have_content(posted_recipe.user.name)
      end
    end

    context "材料での検索" do
      it "全一致で検索可能"do
        posted_recipe
        visit recipes_path
        fill_in "q_title_or_ingredients_content_cont", with: "材料1"
        find("#q_title_or_ingredients_content_cont").send_keys :return
        expect(page).to have_content(posted_recipe.title)
        expect(page).to have_content(posted_recipe.description)
        expect(page).to have_content(posted_recipe.user.name)
      end

      it "部分一致でも可能" do
        posted_recipe
        visit recipes_path
        fill_in "q_title_or_ingredients_content_cont", with: "材料"
        find("#q_title_or_ingredients_content_cont").send_keys :return
        expect(page).to have_content(posted_recipe.title)
        expect(page).to have_content(posted_recipe.description)
        expect(page).to have_content(posted_recipe.user.name)
      end
    end

    it "検索結果が見つからない場合は何も表示されない" do
      posted_recipe
      visit recipes_path
      fill_in "q_title_or_ingredients_content_cont", with: "sample"
      find("#q_title_or_ingredients_content_cont").send_keys :return
      expect(page).to have_content("「sample」の検索結果")
      expect(page).to_not have_content(posted_recipe.title)
      expect(page).to_not have_content(posted_recipe.description)
      expect(page).to_not have_content(posted_recipe.user.name)
    end

    it "検索結果確認後、レシピ一覧ページに戻ことができる" do
      posted_recipe
      visit recipes_path
      fill_in "q_title_or_ingredients_content_cont", with: "レシピのタイトル"
      find("#q_title_or_ingredients_content_cont").send_keys :return
      click_link "レシピ一覧に戻る"
    end
  end
end