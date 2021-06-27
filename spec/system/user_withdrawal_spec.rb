require 'rails_helper'

RSpec.describe "ユーザー退会処理", type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }
  let(:guest_user) { User.guest }

    context "ユーザー退会" do
      before do
        sign_in user
        visit user_path(user)
        click_link 'ユーザー編集'
        click_link '退会する'
      end

      it '退会処理を実施。アカウント復旧をしないとログイン不可', js: true do
        expect(page).to have_content('退会お手続き')
        click_link '退会する'
        expect(page.driver.browser.switch_to.alert.text).to eq "本当に退会しますか？"
        page.driver.browser.switch_to.alert.accept

        expect(page).to have_content('退会処理が完了しました')
        expect(current_path).to eq new_user_session_path

        fill_in 'user_email', with: user.email
        fill_in 'user_password', with: user.password
        click_button 'ログイン'
        expect(current_path).to eq new_user_session_path
        expect(page).to have_content('このアカウントは退会済みです。')
      end

      it '退会処理を実施しない場合は、マイページに戻る' do
        expect(page).to have_content('退会お手続き')
        click_link '退会しない'
        expect(current_path).to eq user_path(user)
      end
    end

    context "退会処理不可" do
      it '他の方の退会処理不可' do
        sign_in user
        visit user_path(other_user)
        visit unsubscribe_user_path(other_user)
        expect(page).to have_content('他の方の退会処理はできません。')
        expect(current_path).to eq root_path
      end

      it 'ゲストユーザーは退会処理不可' do
        visit new_user_session_path
        click_link 'ゲストログイン'
        expect(current_path).to eq root_path
        visit unsubscribe_user_path(guest_user.id)
        expect(page).to have_content('ゲストユーザーの退会処理はできません。')
        expect(current_path).to eq root_path
      end
    end
end