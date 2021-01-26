# == Schema Information
#
# Table name: tags
#
#  id         :bigint           not null, primary key
#  name       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Tag < ApplicationRecord
  has_many :recipe_tag_relations, dependent: :delete_all
  has_many :recipes, through: :recipe_tag_relations

  validates :name, presence: true, uniqueness: true, length: { maximum: 30 }


end
