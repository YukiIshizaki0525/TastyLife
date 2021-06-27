require 'rails_helper'

RSpec.describe "ユーザー退会及び復旧", type: :system do
  let(:user) { create(:user) }

  before do
    sign_in user
    visit user_path(user)
    click_link 'ユーザー編集'
    click_link '退会する'
  end

  describe 'ユーザー退会' do
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

    it 'ゲストユーザーは退会処理不可' do
      
    end
  end
end