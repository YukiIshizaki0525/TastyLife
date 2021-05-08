require 'rails_helper'

RSpec.describe Comment, type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }
  let(:posted_recipe) { create(:recipe, :with_ingredients, :with_steps, user_id: user.id) }
  let(:comment) { build(:comment, recipe_id: posted_recipe.id, user_id: other_user.id) }

  before do
    sign_in other_user
  end

  describe 'コメント投稿機能' do
    context 'フォームの入力値が正常'do
      it '正常に登録される' do
        visit recipe_path(posted_recipe)
        fill_in "comment_comment", with: comment.comment
        click_button '送信する'
        expect(current_path). to eq recipe_path(posted_recipe)
        expect(page).to have_content("コメントを投稿しました")
        expect(page).to have_content( comment.comment )
        expect(page).to have_content( other_user.name )
        expect(page).to have_selector("img[src$='other_user_avatar.jpg']")
      end
    end

    context 'フォームの入力値が異常' do
      it 'コメントが未入力のため投稿不可' do
        visit recipe_path(posted_recipe)
        fill_in "comment_comment", with: nil
        click_button '送信する'

        expect(current_path).to eq recipe_path(posted_recipe)
        expect(page).to have_content("コメントを入力してください")
      end

      it 'コメントが100文字を超える場合は投稿不可' do
        visit recipe_path(posted_recipe)
        fill_in "comment_comment", with: "a" * 101
        click_button '送信する'

        expect(current_path).to eq recipe_path(posted_recipe)
        expect(page).to have_content("コメントは100文字以内で入力してください")
      end
    end
  end

  describe 'コメント表示機能' do
    it '誰でもコメントは閲覧可能' do
      visit recipe_path(posted_recipe)
      fill_in "comment_comment", with: comment.comment
      click_button '送信する'

      sign_in user
      visit recipe_path(posted_recipe)
      expect(page).to have_content( comment.comment )
      expect(page).to have_content( other_user.name )
      expect(page).to have_selector("img[src$='other_user_avatar.jpg']")
    end

    it 'コメントした本人であれば削除ボタンが表示される' do
      visit recipe_path(posted_recipe)
      fill_in "comment_comment", with: comment.comment
      click_button '送信する'
      expect(page).to have_content( comment.comment )
      expect(page).to have_link('delete')
    end

    it '他の方のコメントの場合は削除ボタンが表示されない' do
      visit recipe_path(posted_recipe)
      fill_in "comment_comment", with: comment.comment
      click_button '送信する'

      # ログアウトリンクを押すためブラウザサイズを変更
      page.driver.browser.manage.window.resize_to(1024, 770)
      click_link "ログアウト"

      sign_in user
      visit recipe_path(posted_recipe)
      expect(page).to have_content( comment.comment )
      expect(page).to_not have_link('delete')
    end
  end

  describe '削除機能' do
    it 'コメントした本人であれば削除ボタンからコメントの削除が可能' do
      visit recipe_path(posted_recipe)
      fill_in "comment_comment", with: comment.comment
      click_button '送信する'

      click_link 'delete'
      expect(page.driver.browser.switch_to.alert.text).to eq "削除してよろしいですか？"
      page.driver.browser.switch_to.alert.accept

      expect(page).to have_content 'コメントが削除されました'
      expect(page).to_not have_content( comment.comment )
    end
  end
end