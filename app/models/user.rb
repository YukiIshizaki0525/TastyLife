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
    avatar.variant(resize_to_limit: [100, 100])
  end

end
