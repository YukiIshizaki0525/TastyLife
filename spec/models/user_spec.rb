# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  avatar                 :string(255)
#  confirmation_sent_at   :datetime
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string(255)
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  failed_attempts        :integer          default(0), not null
#  is_deleted             :boolean          default(FALSE), not null
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
#  index_users_on_name                  (name) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_unlock_token          (unlock_token) UNIQUE
#
require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'ユーザー登録' do
    context '正しく登録できる' do
      it "name、email、passwordとpassword_confirmationが存在すれば登録できること" do
        user = build(:user)
        expect(user).to be_valid  # user.valid? が true になればパスする
      end
    end

    context '条件を満たしていないので登録できない' do
      it 'パスワードに英小文字が含まれない場合無効な状態であること' do
        user = User.new(password: '1'+'A' * 5, password_confirmation: '1A'+'a' * 3)
        user.valid?
        expect(user.errors[:password]).to include('は半角6~12文字英大文字・小文字・数字それぞれ１文字以上含む必要があります')
      end

      it 'パスワードが5文字以下なら無効な状態であること' do
        user = User.new(password: '1A'+'a' * 3, password_confirmation: '1A'+'a' * 3)
        user.valid?
        expect(user.errors[:password]).to include('は半角6~12文字英大文字・小文字・数字それぞれ１文字以上含む必要があります')
      end
    end
  end

end
