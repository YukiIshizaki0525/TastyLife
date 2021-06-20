require 'rails_helper'

RSpec.describe "食材管理機能", type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }
  let(:inventory) { build(:inventory) }
  let(:posted_inventory) { create(:inventory, user_id: user.id) }

  before do
    sign_in user
  end

  describe '新規登録' do
    context 'フォームの入力値が正常' do
      it '入力値が正常のため登録可能' do
        visit user_path(user)
        click_link "食材"
        click_link "食材を登録"
        attach_file "inventory[image]", "#{Rails.root}/spec/fixtures/calot.jpg", make_visible: true
        fill_in 'inventory_name', with: inventory.name
        fill_in 'inventory_quantity', with: inventory.quantity
        fill_in 'inventory_expiration_date', with: "002021-05-10"
        fill_in 'inventory_memo', with: inventory.memo
        click_button '送信する'

        expect(page).to have_content("「にんじん」を登録しました。")
        expect(page).to have_selector("img[src$='calot.jpg']")
        expect(page).to have_content("にんじん")
        expect(page).to have_content("3本")
      end

      it '画像とメモは設定されていなくても登録可能' do
        visit user_path(user)
        click_link "食材"
        click_link "食材を登録"
        fill_in 'inventory_name', with: inventory.name
        fill_in 'inventory_quantity', with: inventory.quantity
        fill_in 'inventory_expiration_date', with: "002021-05-10"

        click_button '送信する'

        expect(page).to have_content("「にんじん」を登録しました。")
        expect(page).to have_content("にんじん")
        expect(page).to have_content("3本")
      end
    end

    context 'フォームの入力値が異常' do
      it '食材名・数量・賞味期限が入力されていないため登録不可' do
        visit user_path(user)
        click_link "食材"
        click_link "食材を登録"
        fill_in 'inventory_name', with: nil
        fill_in 'inventory_quantity', with: nil
        fill_in 'inventory_expiration_date', with: nil
        click_button '送信する'
        expect(page).to have_content("食材名を入力してください")
        expect(page).to have_content("数量を入力してください")
        expect(page).to have_content("賞味期限を入力してください")
      end

      it '食材名は20文字・数量は10文字を超える場合は登録不可' do
        visit user_path(user)
        click_link "食材"
        click_link "食材を登録"
        fill_in 'inventory_name', with: "a" * 21
        fill_in 'inventory_quantity', with: "a" * 11
        fill_in 'inventory_expiration_date', with: "002021-05-10"
        fill_in 'inventory_memo', with: inventory.memo

        click_button '送信する'

        expect(page).to have_content("食材名は20文字以内で入力してください")
        expect(page).to have_content("数量は10文字以内で入力してください")
      end

      it '食材画像は3MB以上の場合、登録不可' do
        visit user_path(user)
        click_link "食材"
        click_link "食材を登録"
        attach_file "inventory[image]", "#{Rails.root}/spec/fixtures/pasta_8MB.jpg", make_visible: true
        fill_in 'inventory_name', with: inventory.name
        fill_in 'inventory_quantity', with: inventory.quantity
        fill_in 'inventory_expiration_date', with: "002021-05-10"
        fill_in 'inventory_memo', with: inventory.memo
        click_button '送信する'

        expect(page).to have_content("食材画像は3MB以下のサイズにしてください")
      end
    end
  end

  describe '詳細表示機能' do
    it '他の方の詳細ページに食材管理リンクは表示されない' do
      visit user_path(other_user)
      expect(page).to_not have_content("食材")
    end

    it '直接URLを記載しても食材管理ページは表示されない' do
      visit inventories_user_path(other_user)
      expect(current_path).to eq root_path
      expect(page).to have_content("他人の食材管理ページ閲覧及び編集はできません。")
    end
  end

  describe '編集機能' do
    context '変更反映可能' do
      it '正常な値入力ができていれば反映可能' do
        visit edit_inventory_path(posted_inventory)
        expect(page).to have_field 'inventory_name', with: posted_inventory.name
        expect(page).to have_field 'inventory_quantity', with: posted_inventory.quantity
        attach_file "inventory[image]", "#{Rails.root}/spec/fixtures/tomato.jpg", make_visible: true
        fill_in 'inventory_name', with: "トマト"
        fill_in 'inventory_quantity', with: "3個"
        fill_in 'inventory_expiration_date', with: "002021-05-08"
        fill_in 'inventory_memo', with: "近くのスーパーで5/3に2個購入"

        click_button '送信する'

        expect(page).to have_content("トマト")
        expect(page).to have_content("3個")
        expect(page).to have_selector("img[src$='tomato.jpg']")

      end
    end

    context '変更反映不可' do
      it '食材名・数量を未入力にしたら変更不可' do
        visit edit_inventory_path(posted_inventory)
        fill_in 'inventory_name', with: nil
        fill_in 'inventory_quantity', with: nil
        fill_in 'inventory_expiration_date', with: nil

        click_button '送信する'

        expect(page).to have_content("食材名を入力してください")
        expect(page).to have_content("数量を入力してください")
        expect(page).to have_content("賞味期限を入力してください")
      end

      it "他の方のは食材管理は編集不可" do
        sign_in other_user
        visit edit_inventory_path(posted_inventory)
        expect(current_path).to eq root_path
        expect(page).to have_content("他人の食材管理ページ閲覧及び編集はできません。")
      end
    end
  end

  describe '削除機能' do
    it '食材管理ページからゴミ箱ボタンを押せば食材の削除が可能' do
      visit inventories_user_path(posted_inventory.user)
      click_on 'Delete'

      expect(page.driver.browser.switch_to.alert.text).to eq "削除してよろしいですか？"
      page.driver.browser.switch_to.alert.accept

      expect(current_path).to eq inventories_user_path(user)
      expect(page).to have_content "保存されていた「にんじん」を削除しました。"
    end
  end
end