FactoryBot.define do
  factory :recipe, class: Recipe do
    title { 'テストタイトル' }
    description { 'テストディスクリプション' }

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
