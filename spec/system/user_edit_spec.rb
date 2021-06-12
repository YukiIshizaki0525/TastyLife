require 'rails_helper'

RSpec.describe "ユーザー編集", type: :system do
  let(:user) { create(:user) }
  describe 'ユーザー編集' do
    context 'フォームの入力値が正常' do
      visit edit_user_registration_path
      expect(page).to have_content('アカウント編集')
      expect(page).to have_content, with: user.name
      expect(page).to have_content, with: user.email

      fill_in 'user_name', with: ''
    end

    context 'フォームの入力値が異常のため更新不可' do
      
    end
  end
end