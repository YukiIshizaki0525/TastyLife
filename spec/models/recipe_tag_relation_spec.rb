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
  pending "add some examples to (or delete) #{__FILE__}"
end
