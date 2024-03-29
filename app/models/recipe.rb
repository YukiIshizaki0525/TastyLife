# == Schema Information
#
# Table name: recipes
#
#  id          :bigint           not null, primary key
#  description :text(65535)
#  image       :string(255)
#  title       :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_recipes_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Recipe < ApplicationRecord
  belongs_to :user
  default_scope -> { self.order(created_at: :desc) }

  # 材料・作り方関連
  has_many :ingredients, dependent: :destroy
  accepts_nested_attributes_for :ingredients, allow_destroy: true
  has_many :steps, dependent: :destroy
  accepts_nested_attributes_for :steps, allow_destroy: true

  has_many :comments, dependent: :destroy

  has_many :recipe_tag_relations, dependent: :delete_all, validate: false
  has_many :tags, through: :recipe_tag_relations

  has_many :favorites, dependent: :destroy

  mount_uploader :image, RecipeImageUploader

  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 50}
  validates :description, presence: true, length: { maximum: 140}

  validate :require_any_ingredients
  validate :require_any_steps

  def require_any_ingredients
    errors.add(:base, "材料は1つ以上登録してください。") if self.ingredients.blank?
  end

  def require_any_steps
    errors.add(:base, "作り方は1つ以上登録してください。") if self.steps.blank?
  end

  before_save do
    if remove_image == true
      self.remove_image!
    end
  end
end
