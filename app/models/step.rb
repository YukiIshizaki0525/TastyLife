# == Schema Information
#
# Table name: steps
#
#  id         :bigint           not null, primary key
#  direction  :text(65535)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  recipe_id  :bigint           not null
#
# Indexes
#
#  index_steps_on_recipe_id  (recipe_id)
#
# Foreign Keys
#
#  fk_rails_...  (recipe_id => recipes.id)
#
class Step < ApplicationRecord
  belongs_to :recipe
  validates :direction, presence: true
end
