# == Schema Information
#
# Table name: ingredients
#
#  id         :bigint           not null, primary key
#  content    :string(255)      not null
#  quantity   :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  recipe_id  :bigint           not null
#
# Indexes
#
#  index_ingredients_on_recipe_id  (recipe_id)
#
# Foreign Keys
#
#  fk_rails_...  (recipe_id => recipes.id)
#
class Ingredient < ApplicationRecord
  belongs_to :recipe

    # 材料・分量指定のバリデーション
  validates :content, presence: true
  validates :quantity, presence: true
end
