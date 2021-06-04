# == Schema Information
#
# Table name: steps
#
#  id         :bigint           not null, primary key
#  direction  :text(65535)      not null
#  image      :string(255)
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
  画像投稿に関するバリデーション
  validates :image, content_type: { in: %w[image/jpeg image/gif image/png],
                                    message: "must be a valid image format" },
                    size:         { less_than: 1.megabytes,
                                    message: "1MBの画像を添付してください" }
  
  mount_uploader :image, StepImageUploader
  # レシピ手順の画像
  # has_one_attached :step_image
end
