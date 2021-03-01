# == Schema Information
#
# Table name: consulations
#
#  id         :bigint           not null, primary key
#  content    :text(65535)
#  title      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_consulations_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Consultation, type: :model do
  let(:user) { create(:user) }
  let(:consultation) { build(:consultation, user_id: user.id) }

  describe "正常系" do
    it "正しく登録できること" do
      consultation.save
      consultation.valid?
      expect(consultation.title).to eq('相談タイトル')
      expect(consultation.content).to eq('相談内容')
    end
  end
  

  describe "異常系" do
    context "必須入力であること" do
      it "相談タイトル及び相談内容は必須であること" do
        consultation = build(:consultation, title: nil, content: nil)
        consultation.save
        consultation.valid?

        expect(consultation.errors[:title]).to include("を入力してください")
        expect(consultation.errors[:content]).to include("を入力してください")

      end

    end

    context "文字数制限があること" do
      it "相談タイトルは50文字以内であること" do
        consultation = build(:consultation, title: "a" * 51)
        consultation.save
        consultation.valid?

        expect(consultation.errors[:title]).to include("は50文字以内で入力してください")
      end

      it "相談内容は200文字以内であること" do
        consultation = build(:consultation, content: "a" * 201)
        consultation.save
        consultation.valid?

        expect(consultation.errors[:content]).to include("は200文字以内で入力してください")
      end
    end
  end
end
