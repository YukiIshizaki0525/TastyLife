# == Schema Information
#
# Table name: tags
#
#  id         :bigint           not null, primary key
#  name       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :tag do
    trait :nourishing do
      name {"栄養満点"}
    end
    trait :easy do
      name {"簡単"}
    end
    trait :time_saving do
      name {"時短"}
    end
    trait :cost_performance do
      name {"コスパ◎"}
    end
    trait :longevity do
      name {"日持ち◎"}
    end
    trait :hospitality do
      name {"おもてなし"}
    end
  end
end
