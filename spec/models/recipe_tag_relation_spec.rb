# == Schema Information
#
# Table name: recipe_tag_relations
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  recipe_id  :bigint           not null
#  tag_id     :bigint           not null
#
# Indexes
#
#  index_recipe_tag_relations_on_recipe_id  (recipe_id)
#  index_recipe_tag_relations_on_tag_id     (tag_id)
#
require 'rails_helper'

RSpec.describe RecipeTagRelation, type: :model do
  let(:user) { create(:user) }
  let(:recipe) { create(:recipe, :with_ingredients, :with_steps, user_id: user.id)}
  let(:tag) { create(:tag) }
  let(:recipe_tag) { recipe.recipe_tag_relations.build(tag_id: tag.id) }

  it "タグづけされたレシピが作成可能" do
    subject { recipe_tag }
    expect(recipe_tag).to be_valid
    expect(recipe_tag.tag[:name]).to eq 'タグ1'
  end

  context "必須入力であること" do
    it { is_expected.to validate_presence_of :recipe_id }
    it { is_expected.to validate_presence_of :tag_id }
  end
end
