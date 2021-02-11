class ConsultationsController < ApplicationController
  before_action :set_consultation, only: [:show]

  def index
    @consultations = Consultation.page(params[:page]).order(impressions_count: 'DESC')
    
  end

  def show
    @comments = ConsultationComment.includes(:user).where(consultation_id: @consultation.id)
  
    @comment = @consultation.consultation_comments.new
    @comment_reply = @consultation.consultation_comments.new

    # 閲覧数カウント
    impressionist(@consultation, nil, unique: [:ip_address])
  end

  def new
    @consultation = Consultation.new(flash[:consultation])
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

  private
    def set_consultation
      @consultation = Consultation.find(params[:id])
    end

    def consultation_params
      params.require(:consultation).permit(:title, :content, :user_id)
    end
end
