# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  confirmation_sent_at   :datetime
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string(255)
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  failed_attempts        :integer          default(0), not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string(255)
#  locked_at              :datetime
#  name                   :string(255)
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  sign_in_count          :integer          default(0), not null
#  unconfirmed_email      :string(255)
#  unlock_token           :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_name                  (name) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#
class User < ApplicationRecord
  attr_accessor :login
  has_many :recipes, dependent: :destroy
  has_many :active_relationships,
              class_name:  "Relationship",
              foreign_key: "follower_id",
              dependent:   :destroy

  has_many :passive_relationships,
              class_name:  "Relationship",
              foreign_key: "followed_id",
              dependent:   :destroy

  has_many :following,
              through: :active_relationships,
              source: :followed

  has_many :followers,
              through: :passive_relationships,
              source: :follower
  # アイコン画像追加のため
  has_one_attached :avatar

  validates :name,
            presence: true,
            uniqueness: { case_sensitive: false }
  validates :avatar, content_type: { in: %w[image/jpeg image/gif image/png],
                               message: "は有効な画像形式である必要があります" },
                    size:         { less_than: 1.megabytes,
                                      message: "は1MB未満である必要があります" }
  validates_format_of :name,
                      with: /^[a-zA-Z0-9_¥.]*$/,
                      multiline: true
  validate :validate_name

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable

  def login=(login)
    @login = login
  end

  # username,emailでの認証が可能
  def login
    @login || self.name || self.email
  end

  # ログイン時にusernameかemailで認証させるためオーバーライド
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    conditions[:email].downcase! if conditions[:email]
    login = conditions.delete(:login)

    where(conditions.to_hash).where(
      ["lower(name) = :value OR lower(email) = :value",
        { value: login.downcase }]
      ).first
  end

  def validate_name
    errors.add(:name, :invalid) if User.where(email: name).exists?
  end

  def display_avatar
    avatar.variant(combine_options: {resize_to_fill: [200, 200], border:5})
  end
  
  def follow(other_user)
    self.following << other_user
  end

  # ユーザーをフォロー解除する
  def unfollow(other_user)
    self.active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # 現在のユーザーがフォローしてたらtrueを返す
  def following?(other_user)
    self.following.include?(other_user)
  end

  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE follower_id = :user_id"
    Recipe.where("user_id IN (#{following_ids}) OR user_id = :user_id",
                                   user_id: self.id)
  end
end
