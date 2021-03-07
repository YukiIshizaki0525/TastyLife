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
FactoryBot.define do
  factory :ingredients, class: Ingredient do
    content { "材料1" }
    quantity { "分量1" }
  end
end
