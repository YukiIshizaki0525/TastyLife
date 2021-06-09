# == Schema Information
#
# Table name: inventories
#
#  id              :bigint           not null, primary key
#  expiration_date :date             not null
#  image           :string(255)
#  memo            :text(65535)
#  name            :string(255)      not null
#  quantity        :string(255)      not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  user_id         :bigint           not null
#
# Indexes
#
#  index_inventories_on_user_id  (user_id)
#
require 'rails_helper'

RSpec.describe Inventory, type: :model do
  let(:inventory) { build(:inventory) }

  describe "正常系" do
    it '登録可能' do
      expect(inventory.name).to eq("にんじん")
      expect(inventory.quantity).to eq("3本")
      expect(inventory.expiration_date.to_s).to eq("2021-05-10")
      expect(inventory.memo).to eq("近くのスーパーで5/2に購入")
      expect(inventory).to be_valid
    end

    it '画像とメモは設定されていなくても登録可能' do
      inventory = build(:inventory, memo: nil)
      expect(inventory).to be_valid
    end
  end

  describe "異常系" do
    context '必須入力であること' do
      it "食材名・数量・賞味期限は必須であること" do
        is_expected.to validate_presence_of :name
        is_expected.to validate_presence_of :quantity
        is_expected.to validate_presence_of :expiration_date
      end
    end

    context '文字数制限' do
      it "食材名は20文字以内であること" do
        inventory = build(:inventory, name: "a" * 21)
        inventory.save
        inventory.valid?

        expect(inventory.errors[:name]).to include("は20文字以内で入力してください")
      end

      it "数量は10文字以内であること" do
        inventory = build(:inventory, quantity: "a" * 11)
        inventory.save
        inventory.valid?

        expect(inventory.errors[:quantity]).to include("は10文字以内で入力してください")
      end
    end

    it "食材画像サイズが3MB以上だと登録不可" do
      inventory.image = fixture_file_upload("pasta_8MB.jpg")
      inventory.save

      inventory.valid?
      expect(inventory.errors.full_messages.first).to eq("食材画像は3MB以下のサイズにしてください")
    end
  end
end
