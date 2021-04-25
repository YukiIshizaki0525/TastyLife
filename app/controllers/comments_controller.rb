class CommentsController < ApplicationController
  def create
    comment = Comment.new(comment_params)
    if comment.save
      flash[:notice] = 'コメントを投稿しました'
      redirect_to comment.recipe
    else
      redirect_back fallback_location: comment.recipe, flash: {
        comment: comment,
        error_messages: comment.errors.full_messages
      }
    end
  end

  def destroy
    comment = Comment.find_by(id: params[:id], recipe_id: params[:recipe_id]).destroy
    redirect_to comment.recipe, flash: { notice: 'コメントが削除されました' }
  end

  private

  def comment_params
    params.require(:comment).permit(:user_id, :recipe_id, :reply_comment, :name, :content)
  end
end
