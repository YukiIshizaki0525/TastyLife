# == Schema Information
#
# Table name: favorites
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  recipe_id  :integer
#  user_id    :integer
#
class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :recipe
  counter_culture :recipe

  validates_uniqueness_of :recipe_id, scope: :user_id
end
