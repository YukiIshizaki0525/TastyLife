class Recipe < ApplicationRecord
  has_many :ingredients, dependent: :destroy
  accepts_nested_attributes_for :ingredients, allow_destroy: true
  has_many :steps, dependent: :destroy
  accepts_nested_attributes_for :steps, allow_destroy: true

  has_one_attached :image

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
