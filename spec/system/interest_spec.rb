require 'rails_helper'

RSpec.describe "相談気になる機能", type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }
  let(:consultation) { create(:consultation, user_id: other_user.id) }
  let(:interest) { user.interests.create(consultation_id: consultation.id) }
  let(:destroy_interest) { user.interests.find_by(consultation_id: consultation.id).destroy }

  before do
    sign_in user
  end

  context '相談詳細ページからの気になる機能について' do
    it '気になる登録をする' do
      visit consultation_path(consultation)
      expect(page).to have_selector '.fas'
      expect(page).to have_selector '.fa-star'
      expect(consultation.interests.length).to eq(0)

      expect{ find(".interest__link").find(".fa-star").click }.to change {
      Interest.count }.by(1)
    end

    it '気になる登録した相談を解除' do
      interest
      visit consultation_path(consultation)
      expect(page).to have_selector '.fas'
      expect(page).to have_selector '.fa-star'
      expect(consultation.interests.length).to eq(1)

      expect{ find(".interest__delete-link").find(".fa-star").click }.to change {
      Interest.count }.by(0)
    end
  end

  context "ユーザー詳細ページにいいねしたレシピが表示される点について" do
    it '気になる登録した投稿が表示される' do
      interest
      visit interests_user_path(user)
      expect(page).to have_content("Interest")
      expect(page).to have_content("相談タイトル")
      expect(consultation.interests.length).to eq(1)
    end

    it '気になる登録した投稿を解除する' do
      interest
      visit consultation_path(consultation)
      find(".interest__delete-link").find(".fa-star").click
      visit interests_user_path(user)
      expect(page).to have_content("Interest")
      expect(page).to have_content("#{user.name}さんが気になっている相談はありません。")
    end
  end
end