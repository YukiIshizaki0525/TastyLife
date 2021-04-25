class ConsultationCommentsController < ApplicationController
  def create
    comment = ConsultationComment.create(comment_params)
    if comment.save
      flash[:notice] = '相談に対するコメントを投稿しました'
      redirect_to comment.consultation
    else
      if comment.reply_comment.nil?
        flash[:comment] = comment
      else
        flash[:comment_reply] = comment
      end
      
      flash[:error_messages] = comment.errors.full_messages
      redirect_back fallback_location: comment.consultation
    end
  end

  def destroy
    comment = ConsultationComment.find_by(id: params[:id], consultation_id: params[:consultation_id]).destroy
    redirect_to comment.consultation, flash: { notice: 'コメントが削除されました' }
  end

  private
    def comment_params
      params.require(:consultation_comment).permit(:content, :reply_comment, :user_id, :consultation_id)
    end
end
