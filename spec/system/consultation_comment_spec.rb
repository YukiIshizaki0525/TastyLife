require 'rails_helper'

RSpec.describe ConsultationComment, type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }
  let(:consultation) { create(:consultation, user_id: other_user.id) }
  let(:comment) { build(:consultation_comment, consultation_id: consultation.id, user_id: user.id) }
  let(:posted_comment) { create(:consultation_comment, consultation_id: consultation.id, user_id: user.id) }
  let(:reply) { build(:consultation_comment, :reply, reply_comment: posted_comment.id, user_id: user.id) }

  before do
    sign_in user
  end

  describe 'コメント投稿機能' do
    context 'フォームの入力値が正常'do
      it '正常に登録される' do
        visit consultation_path(consultation)
        fill_in "consultation_comment_content", with: comment.content
        click_button '送信する'
        expect(current_path). to eq consultation_path(consultation)
        expect(page).to have_content("相談へのコメントを投稿しました。")
        expect(page).to have_content( comment.content )
      end
    end

    context 'フォームの入力値が異常' do
      it 'コメントが未入力のため投稿不可' do
        visit consultation_path(consultation)
        fill_in "consultation_comment_content", with: nil
        click_button '送信する'
        expect(current_path). to eq consultation_path(consultation)
        expect(page).to have_content("コメントを入力してください")
      end

      it 'コメントが100文字を超える場合は投稿不可' do
        visit consultation_path(consultation)
        fill_in "consultation_comment_content", with: "a" * 101
        click_button '送信する'
        expect(current_path). to eq consultation_path(consultation)
        expect(page).to have_content("コメントは100文字以内で入力してください")
      end
    end
  end

  describe 'コメント表示機能' do
    it '誰でもコメントは閲覧可能' do
      posted_comment
      visit consultation_path(consultation)
      expect(page).to have_content( posted_comment.content )
      expect(page).to have_selector("img[src$='avatar.jpg']")
    end

    it 'コメントした本人であれば削除ボタンが表示される' do
      posted_comment
      visit consultation_path(consultation)
      expect(page).to have_content( posted_comment.content )
      expect(page).to have_link("delete")
    end

    it '他の方のコメントの場合は削除ボタンが表示されない' do
      sign_in other_user
      posted_comment
      visit consultation_path(consultation)
      expect(page).to have_content( posted_comment.content )
      expect(page).to_not have_link("delete")
    end

    it "ログインしていない場合はコメント投稿フォームが表示されない" do
      sign_out user
      visit consultation_path(consultation)
      expect(page).to_not have_css '.comment__form'
      expect(page).to_not have_content("コメント投稿はこちら")
    end
  end

  describe 'コメント削除機能' do
    it 'コメントした本人であれば削除ボタンからコメントの削除が可能', js: true do
      posted_comment
      visit consultation_path(consultation)
      click_link 'delete'
      expect(page.driver.browser.switch_to.alert.text).to eq "削除してよろしいですか？"
      page.driver.browser.switch_to.alert.accept

      expect(page).to have_content 'コメントを削除しました。'
      expect(page).to_not have_content( posted_comment.content )
    end
  end

  describe 'コメント返信機能' do
    it 'コメント返信可能' do
      posted_comment
      visit consultation_path(consultation)
      fill_in "consultation_comment_content", with: reply.content, match: :first
      click_button 'send-comment'
      expect(current_path). to eq consultation_path(consultation)
      expect(page).to have_content("コメントに返信しました。")
      expect(page).to have_content( reply.content )
      expect(page).to have_content( reply.user.name )
    end
  end
end

