require 'rails_helper'

RSpec.describe "ユーザー編集", type: :system do
  let(:user) { create(:user) }

  before do
    sign_in user
    visit user_path(user)
    click_link 'ユーザー編集'
  end

  describe 'ユーザー編集' do
    context 'フォームの入力値が正常' do
      it 'ユーザー名・プロフィール画像・パスワードを変更する場合' do
        expect(page).to have_content('アカウント編集')
        expect(page).to have_selector("img[src$='avatar.jpg']")

        fill_in 'user_name', with: 'Bob'
        fill_in 'user_password', with: "Sample123"
        fill_in 'user_password_confirmation', with: "Sample123"
        attach_file 'user_avatar', "#{Rails.root}/spec/fixtures/change_after_avatar.jpg", make_visible: true

        click_button '更新'
        expect(current_path).to eq user_path(user)
        expect(page).to have_content('アカウント情報を変更しました')
        expect(page).to have_selector("img[src$='change_after_avatar.jpg']")
        expect(page).to have_content('Bob')
      end

      it 'メールアドレスを変更する場合' do
        fill_in 'user_email', with: 'Bob@example.com'
        click_button '更新'
        expect(current_path).to eq user_path(user)
        expect(page).to have_content('アカウント情報を変更しました。変更されたメールアドレスの本人確認のため、本人確認用メールよりメールアドレス変更手続きをおこなってください。')
        expect(ActionMailer::Base.deliveries.size).to eq 1
      end
    end

    context 'フォームの入力値が異常のため更新不可' do
      it 'ユーザー名とメールアドレスが入っていないため、再度ユーザー編集ページへ' do
        fill_in 'user_name', with: nil
        fill_in 'user_email', with: nil
        click_button '更新'

        expect(current_path).to eq users_path
        expect(page).to have_content('ユーザー名を入力してください')
        expect(page).to have_content('Eメールを入力してください')
      end

      it 'メールアドレスが不正な値であるため、再度ユーザー編集ページへ' do
        fill_in 'user_email', with: "Bob@example"
        click_button '更新'

        expect(current_path).to eq users_path
        expect(page).to have_content('Eメールは不正な値です')
      end

      it 'パスワードが一致しないため、再度ユーザー編集ページへ' do
        fill_in 'user_password', with: "Sample"
        fill_in 'user_password_confirmation', with: "Sample2"
        click_button '更新'

        expect(current_path).to eq users_path
        expect(page).to have_content('パスワード（確認用）とパスワードの入力が一致しません')
      end

      it 'プロフィール画像が3MB以上の場合は更新不可' do
        attach_file "user_avatar", "#{Rails.root}/spec/fixtures/pasta_8MB.jpg", make_visible: true
        click_button '更新'

        expect(current_path).to eq users_path
        expect(page).to have_content("プロフィール画像は3MB以下のサイズにしてください")
      end
    end
  end

  it 'ゲストユーザーの編集及び退会処理不可'
end