# == Schema Information
#
# Table name: favorites
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  recipe_id  :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_favorites_on_recipe_id  (recipe_id)
#  index_favorites_on_user_id    (user_id)
#
require 'rails_helper'

RSpec.describe Favorite, type: :model do
  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }
  let(:recipe) { create(:recipe, :with_ingredients, :with_steps, user_id: other_user.id) }
  let(:favorite) { user.favorites.create(recipe_id: recipe.id)}
  let(:destroy_favorite) { user.favorites.find_by(recipe_id: recipe.id).destroy }

  it "レシピにいいね可能" do
    expect(favorite.user.name).to eq "Alice"
    expect(favorite.recipe.title).to eq "レシピのタイトル"
    expect(user.favorites.count).to eq 1
  end
  
  it "いいね済みであれば「いいね」解除可能" do
    expect{ favorite }.to change{ Favorite.count }.by(1)
    expect{ destroy_favorite }.to change{ Favorite.count }.by(-1)
    expect(user.favorites.count).to eq 0
  end

  it "1人が1つの投稿に対して、1つしかいいねをつけられないこと" do
    favorite
    is_expected.to validate_uniqueness_of(:recipe_id).scoped_to(:user_id)
  end

end
