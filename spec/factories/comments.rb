# == Schema Information
#
# Table name: comments
#
#  id            :bigint           not null, primary key
#  content       :text(65535)      not null
#  reply_comment :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  recipe_id     :bigint           not null
#  user_id       :bigint           not null
#
# Indexes
#
#  index_comments_on_recipe_id  (recipe_id)
#  index_comments_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (recipe_id => recipes.id)
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :comment, class: Comment do
    content { 'レシピに対するコメントです。' }

     trait :reply do
      content { "コメントへの返信です。" }
    end
  end
end
