class ConsultationCommentsController < ApplicationController
  def create
    @comment = ConsultationComment.new(comment_params)
    if @comment.save
      flash[:notice] = '相談に対するコメントを投稿しました'
      redirect_to @comment.consultation
    else
      flash[:consultation_comment] = @comment
      flash[:error_messages] = @comment.errors.full_messages
      redirect_back fallback_location: @comment.consultation
    end
  end

  def destroy
    @comment = ConsultationComment.find(params[:id]).destroy
    redirect_to @comment.consultation, flash: { notice: 'コメントが削除されました' }
  end

  private
    def comment_params
      params.require(:consultation_comment).permit(:content, :reply_comment, :user_id, :consultation_id)
    end
end
