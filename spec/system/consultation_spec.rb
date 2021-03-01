require 'rails_helper'

RSpec.describe "レシピ相談機能", type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }
  let(:consultation) { build(:consultation, user_id: user.id) }
  let(:posted_consultation) { create(:consultation, user_id: user.id) }

  before do
    sign_in user
  end

  describe '新規作成機能' do
    context 'フォームの入力値が正常'do
      it '正常に登録される' do
        visit new_consultation_path
        fill_in 'consultation_title', with: consultation.title
        fill_in 'consultation_content', with: consultation.content
        expect { click_button '送信する' }.to change { Consultation.count }.by(1)
        # expect(current_path).to eq consultation_path(consultation)

        expect(page).to have_content("「#{consultation.title}」の相談を投稿しました。")
        expect(page).to have_selector("img[src$='avatar.jpg']")
        expect(page).to have_content(user.name)
        expect(page).to have_content(consultation.title)
        expect(page).to have_content(consultation.content)
        expect(page).to have_content(consultation.created_at)
      end
    end

    context 'フォームの入力値が異常' do
      it '相談タイトル・相談内容が入っていないため登録不可' do
        visit new_consultation_path
        fill_in 'consultation_title', with: nil
        fill_in 'consultation_content', with: nil
        click_button '送信する'

        expect(current_path).to eq new_consultation_path
        expect(page).to have_content("相談タイトルを入力してください")
        expect(page).to have_content("相談内容を入力してください")
      end

      it '相談タイトルは50文字・相談内容は200文字を超える場合は登録不可' do
        visit new_consultation_path
        fill_in 'consultation_title', with:  "a" * 51
        fill_in 'consultation_content', with:  "a" * 201
        click_button '送信する'

        expect(current_path).to eq new_consultation_path
        expect(page).to have_content("相談タイトルは50文字以内で入力してください")
        expect(page).to have_content("相談内容は200文字以内で入力してください")
      end
    end
  end

  describe '詳細表示機能' do
    it '誰でも相談詳細を閲覧可能' do
      visit consultation_path(posted_consultation)
      expect(page).to have_selector("img[src$='avatar.jpg']")
      expect(page).to have_content(user.name)
      expect(page).to have_content(posted_consultation.title)
      expect(page).to have_content(posted_consultation.content)
    end

    it '別の方の相談は相談編集リンクが表示されない' do
      sign_in other_user
      visit consultation_path(posted_consultation)
      expect(page).to_not have_content("編集")
    end
  end

  describe '編集機能' do
    context '変更反映可能' do
      it '正常な値入力ができていれば反映可能' do
        visit edit_consultation_path(posted_consultation)
        expect(page).to have_field 'consultation_title', with: posted_consultation.title
        expect(page).to have_field 'consultation_content', with: posted_consultation.content
        fill_in 'consultation_title', with: '変更後の相談タイトル'
        fill_in 'consultation_content', with: '変更後の相談内容'
      end
    end

    context '変更反映不可' do
      it '相談タイトル・内容を未入力にしたら変更反映不可' do
        visit edit_consultation_path(posted_consultation)
        expect(page).to have_field 'consultation_title', with: posted_consultation.title
        expect(page).to have_field 'consultation_content', with: posted_consultation.content
        fill_in 'consultation_title', with: nil
        fill_in 'consultation_content', with: nil
      end
    end

    it '編集を中断し、詳細ページに戻ることができる' do
      visit edit_consultation_path(posted_consultation)
      click_link '編集をやめる'
      expect(current_path).to eq consultation_path(posted_consultation)
    end

    it "他の方の相談は編集不可" do
      sign_in other_user
      visit edit_consultation_path(posted_consultation)
      expect(current_path).to eq root_path
      expect(page).to have_content("他人の相談は編集できません")
    end
  end

  describe '削除機能' do
    it '編集ページから削除ボタンを押せば相談の削除が可能' do
      visit edit_consultation_path(posted_consultation)
      expect { click_link 'この相談を削除' }.to change { Consultation.count }.by(-1)
      expect(current_path).to eq consultations_user_path(user.id)

      expect(page).to have_content("「#{posted_consultation.title}」の相談を削除しました。")
    end
  end
end