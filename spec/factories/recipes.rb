# == Schema Information
#
# Table name: recipes
#
#  id          :bigint           not null, primary key
#  description :text(65535)
#  title       :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint
#
# Indexes
#
#  index_recipes_on_user_id                 (user_id)
#  index_recipes_on_user_id_and_created_at  (user_id,created_at)
#
FactoryBot.define do
  factory :recipe, class: Recipe do
    title { 'テストタイトル' }
    description { 'テストディスクリプション' }

    # association :user

    trait :with_ingredients do
      after(:build) do |recipe|
        ingredient = build(:ingredients)
        recipe.ingredients << ingredient
      end
    end

    trait :with_steps do
      after(:build) do |recipe|
        step = build(:steps)
        recipe.steps << step
      end
    end
  end
end
