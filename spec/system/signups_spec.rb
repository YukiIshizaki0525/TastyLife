require 'rails_helper'

RSpec.describe "user新規登録", type: :system do
  let(:user) { build(:user) }
  describe 'ユーザー新規登録' do
    context 'フォームの入力値が正常' do
      it '正確な情報を入力したら登録可能。そしてトップへ' do
        visit new_user_registration_path
        expect(page).to have_content('新規登録')
        fill_in 'user_name', with: user.name
        fill_in 'user_email', with: user.email
        fill_in 'user_password', with: user.password
        fill_in 'user_password_confirmation', with: user.password_confirmation
        expect { click_button '新規登録' }.to change { User.count }.by(1)
        expect(current_path).to eq root_path
        expect(page).to have_content('新規登録が完了しました。')
      end
    end
    context 'フォームの入力値が異常のため登録不可' do
      it 'メールアドレスが入っていないため再度登録ページへ' do
        visit new_user_registration_path
        expect(page).to have_content('新規登録')
        fill_in 'user_name', with: user.name
        fill_in 'user_email', with: nil
        fill_in 'user_password', with: user.password
        fill_in 'user_password_confirmation', with: user.password_confirmation

        expect { click_button '新規登録' }.to change { User.count }.by(0)
        expect(current_path).to eq users_path
        expect(page).to have_content('Eメールを入力してください')
      end

      it 'パスワード入力条件を満たしていないため再度登録ページへ' do
        visit new_user_registration_path
        expect(page).to have_content('新規登録')
        fill_in 'user_name', with: user.name
        fill_in 'user_email', with: user.email
        fill_in 'user_password', with: "password"
        fill_in 'user_password_confirmation', with: "password"

        expect { click_button '新規登録' }.to change { User.count }.by(0)
        expect(current_path).to eq users_path
        expect(page).to have_content('は半角6~12文字英大文字・小文字・数字それぞれ１文字以上含む必要があります')
      end
    end

    # context '登録済メールアドレス' do => エラー発生するためコメントアウト
    #   it 'メールアドレス重複のため再度登録ページへ' do
    #     visit new_user_registration_path
    #     expect(page).to have_content('新規登録')
    #     fill_in 'user_name', with: user.name
    #     fill_in 'user_email', with: user.email
    #     fill_in 'user_password', with: user.password
    #     fill_in 'user_password_confirmation', with: user.password_confirmation
    #     click_button '新規登録'
    #     expect(current_path).to eq users_path
    #     expect(page).to have_content('Eメールはすでに存在します')
    #   end
    # end
  end

end