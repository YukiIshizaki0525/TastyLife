# == Schema Information
#
# Table name: consultation_comments
#
#  id              :bigint           not null, primary key
#  content         :text(65535)      not null
#  reply_comment   :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  consultation_id :bigint           not null
#  user_id         :bigint           not null
#
# Indexes
#
#  index_consultation_comments_on_consultation_id  (consultation_id)
#  index_consultation_comments_on_user_id          (user_id)
#
require 'rails_helper'

RSpec.describe ConsultationComment, type: :model do
  let(:user) { create(:user) }
  let(:other_user) { create(:other_user) }
  let(:consultation) { create(:consultation, user_id: other_user.id) }
  let(:comment) { build(:consultation_comment, consultation_id: consultation.id, user_id: user.id) }
  let(:posted_comment) { create(:consultation_comment, consultation_id: consultation.id, user_id: user.id) }
  let(:reply) { build(:consultation_comment, :reply, reply_comment: posted_comment.id, user_id: user.id) }

  describe '正常系' do
    it '正しくコメント投稿できること' do
      comment.valid?
      expect(comment.content).to eq('相談に対するコメントです。')
    end

    it '正しくコメント返信できること' do
      reply.valid?
      expect(reply.content).to eq('コメントへの返信です。')
      expect(posted_comment.id).to eq( reply.reply_comment )
    end
  end

  describe '異常系' do
    context "未入力だとコメント投稿不可" do
      it '未入力の場合、コメント投稿ができない' do
        comment = build(:consultation_comment, content: nil)
        comment.valid?
        expect(comment.errors[:content]).to include("を入力してください")
      end

      it '未入力の場合、コメント返信ができない' do
        reply = build(:consultation_comment, :reply, content: nil)
        reply.valid?
        expect(reply.errors[:content]).to include("を入力してください")
      end
    end

    context "文字数制限" do
      it "コメントは100文字以内であること" do
        comment = build(:consultation_comment, content: "a" * 101)
        comment.valid?

        expect(comment.errors[:content]).to include("は100文字以内で入力してください")
      end

      it "コメントへの返信も100文字以内であること" do
        reply = build(:consultation_comment, :reply, content: "a" * 101)
        reply.valid?

        expect(reply.errors[:content]).to include("は100文字以内で入力してください")
      end
    end
  end
end
