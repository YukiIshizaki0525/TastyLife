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
class Comment < ApplicationRecord
  belongs_to :recipe
  belongs_to :user

  has_many :replies, class_name: :Comment, foreign_key: :reply_comment, dependent: :destroy

  validates :content, presence: true, length: { maximum: 100 }
end
