# == Schema Information
#
# Table name: recipes
#
#  id          :bigint           not null, primary key
#  description :text(65535)
#  title       :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint
#
# Indexes
#
#  index_recipes_on_user_id                 (user_id)
#  index_recipes_on_user_id_and_created_at  (user_id,created_at)
#
class Recipe < ApplicationRecord
  belongs_to :user
  default_scope -> { self.order(created_at: :desc)}

  has_many :ingredients, dependent: :destroy
  accepts_nested_attributes_for :ingredients, allow_destroy: true
  has_many :steps, dependent: :destroy
  accepts_nested_attributes_for :steps, allow_destroy: true

  has_one_attached :image

  # レシピ投稿に関するバリデーション
  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 50}
  validates :description, presence: true, length: { maximum: 140}

  # 画像投稿に関するバリデーション
  validates :image, content_type: { in: %w[image/jpeg image/gif image/png],
                                    message: "must be a valid image format" },
                    size:         { less_than: 1.megabytes,
                                    message: "should be less than 1MB" }

  # リサイズ済みの画像を表示（縦横500pxを超えないようにする）
  def display_image
    image.variant(resize_to_limit: [500, 500])
  end

end
