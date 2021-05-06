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
class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :recipe

  validates_uniqueness_of :recipe_id, scope: :user_id
end
