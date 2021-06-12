class ConsultationsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_consultation, only: [:show, :edit, :update, :destroy]

  def index
    unless params[:q].present?
      params[:q] = { sorts: 'created_at desc' }
    end

    @q = Consultation.ransack(params[:q])
    @consultations = @q.result.includes([:user], [:interests]).page(params[:page]).per(6)
  end

  def show
    @comments = ConsultationComment.includes(:consultation).where(consultation_id: @consultation.id)

    if user_signed_in?
      @new_comment = current_user.consultation_comments.new(flash[:comment])
      @comment_reply = current_user.consultation_comments.new
    end
  end

  def new
    @consultation = Consultation.new(flash[:consultation])
  end

  def edit
    if @consultation.user == current_user
      render "edit"
    else
      redirect_back fallback_location: root_path, flash: { alert: "他人の相談は編集できません" }
    end
  end

  def create
    consultation = current_user.consultations.new(consultation_params)
    if consultation.save
      redirect_to consultation, flash: { notice: "「#{consultation.title}」の相談を投稿しました。" }
    else
      redirect_to new_consultation_path, flash: {
        consultation: consultation,
        error_messages: consultation.errors.full_messages
      }
    end
  end

  def update
    @consultation.update(consultation_params)
    if @consultation.save
      redirect_to @consultation, flash: { notice: "「#{@consultation.title}」の相談を更新しました。" }
    else
      flash[:consultation] = @consultation
      flash[:error_messages] = @consultation.errors.full_messages
      redirect_back fallback_location: @consultation
    end
  end

  def destroy
    @consultation.destroy
    redirect_to consultations_user_path(current_user.id), flash: { notice: "「#{@consultation.title}」の相談を削除しました。" }
  end

  private
    def set_consultation
      @consultation = Consultation.find(params[:id])
    end

    def consultation_params
      params.require(:consultation).permit(:title, :content, :user_id)
    end
end
