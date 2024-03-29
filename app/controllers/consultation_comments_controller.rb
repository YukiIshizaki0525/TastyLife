class ConsultationCommentsController < ApplicationController
  def create
    comment = ConsultationComment.new(comment_params)
    if comment.save
      if comment.reply_comment.nil?
        flash[:notice] = '相談へのコメントを投稿しました。'
      else
        flash[:notice] = 'コメントに返信しました。'
      end
      redirect_to comment.consultation
    else
      if comment.reply_comment.nil?
        flash[:comment] = comment
      end
      flash[:error_messages] = comment.errors.full_messages
      redirect_back fallback_location: comment.consultation
    end
  end

  def destroy
    comment = ConsultationComment.find_by(id: params[:id], consultation_id: params[:consultation_id]).destroy
    redirect_to comment.consultation
    if comment.reply_comment.nil?
      flash[:notice] = 'コメントを削除しました。'
    else
      flash[:notice] = '返信したコメントを削除しました。'
    end
  end

  private
    def comment_params
      params.require(:consultation_comment).permit(:content, :reply_comment, :user_id, :consultation_id)
    end
end
