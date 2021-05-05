require 'rails_helper'

RSpec.describe "レシピいいね機能", type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }
  let!(:recipe) { create(:recipe, :with_ingredients, :with_steps, user_id: other_user.id) }
  let(:favorite) { user.favorites.create(recipe_id: recipe.id)}
  let(:destroy_favorite) { user.favorites.find_by(recipe_id: recipe.id).destroy }

  before do
    sign_in user
  end

  context ' レシピ一覧ページからのいいね機能について' do
    it 'いいねする' do
      visit recipes_path
      expect(page).to have_selector '.far'
      expect(page).to have_selector '.fa-heart'
      expect(recipe.favorites.length).to eq(0)
      find(".favorite__link").find(".fa-heart").click

      expect{ find(".favorite__link").find(".fa-heart").click }.to change { Favorite.count }.by(1)
    end

    it 'いいねを解除' do
      favorite
      visit recipes_path
      expect(page).to have_selector '.fas'
      expect(page).to have_selector '.fa-heart'
      expect(recipe.favorites.length).to eq(1)
      expect{ find(".favorite__link").find(".fa-heart").click }.to change { Favorite.count }.by(0)
    end
  end

  context 'レシピ詳細ページからのいいね機能について' do
    it 'いいねする' do
      visit recipe_path(recipe)
      expect(page).to have_selector '.far'
      expect(page).to have_selector '.fa-heart'
      expect(recipe.favorites.length).to eq(0)
      find(".favorite__link").find(".fa-heart").click

      expect{ find(".favorite__link").find(".fa-heart").click }.to change { Favorite.count }.by(1)
    end

    it 'いいねを解除' do
      favorite
      visit recipe_path(recipe)
      expect(page).to have_selector '.fas'
      expect(page).to have_selector '.fa-heart'
      expect(recipe.favorites.length).to eq(1)

      expect{ find(".favorite__link").find(".fa-heart").click }.to change { Favorite.count }.by(0)
    end
  end

  context 'ユーザー詳細ページからのいいね機能について' do
    it 'いいねした投稿が表示される' do
      visit recipe_path(recipe)
      find(".favorite__link").find(".fa-heart").click
      visit favorites_user_path(user)
      expect(page).to have_content("Favorite")
      expect(page).to have_content("テストタイトル")
      expect(recipe.favorites.length).to eq(1)
    end

    it 'いいねした投稿を解除する' do
      favorite
      visit favorites_user_path(user)
      expect(page).to have_content("Favorite")
      find(".favorite__link").find(".fa-heart").click
      visit favorites_user_path(user)
      expect(page).to have_content("#{user.name}さんがいいねしたレシピはありません。")
    end
  end
end