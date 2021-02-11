class AddReplyCommentToConsultationComments < ActiveRecord::Migration[6.0]
  def change
    add_column :consultation_comments, :reply_comment, :int
  end
end
