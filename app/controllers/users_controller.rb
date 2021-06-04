class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:destroy, :inventories]
  before_action :set_user, except: [:index, :restore_mail]
  before_action :withdrawal_forbid_guest_user, only: [:unsubscribe, :withdrawal]

  def index
    @users = User.includes(:recipes).page(params[:page]).per(6).order(id: :ASC)
  end

  def show
    @recipes = @user.recipes.includes(:favorites).page(params[:page]).per(6)
  end

  def destroy
    @user.destroy
    redirect_to users_url, success: "「#{@user.name}を削除しました」"
  end

  def following
    @title = "さんがフォロー中"
    @message = "まだ誰もフォローしていません。"
    @users = @user.following.includes(:recipes).page(params[:page]).per(6)
    render 'show_follow'
  end


  def followers
    @title = "さんのフォロワー"
    @message = "まだ誰からもフォローされていません。"
    @users = @user.followers.includes(:recipes).page(params[:page]).per(6)
    render 'show_follow'
  end

  def consultations
    @title = "Consultation"
    @consultations = @user.consultations.includes([:consultation_comments], [:interests]).page(params[:page]).per(3)
    render 'show_consultation'
  end

  def favorites
    @title = "Favorite"
    @recipes = @user.favorite_recipes.includes(:favorites).page(params[:page]).per(6)
    render 'show_favorite'
  end

  def interests
    @title = "Interest"
    @consultations = @user.interest_consultations.includes([:interests]).page(params[:page]).per(6)
    render 'show_interest'
  end

  def inventories
    if user_signed_in? && @user.id == current_user.id
      @title = "Inventory"
      @inventories = @user.inventoriespage(params[:page]).order(expiration_date: 'ASC').per(6)
      render 'show_inventory'
    else
      flash[:alert] = "他人の食材管理ページ閲覧及び編集はできません。"
      redirect_to root_path
    end
  end

  def withdrawal
    @user.update(is_deleted: true)
    reset_session
    flash[:notice] = "退会処理が完了しました。"
    redirect_to new_user_session_path
  end

  def restore_mail
    @user = User.find_by(email: params[:email])
    if @user.is_deleted
      RestoreMailer.send_when_restore(params[:email]).deliver
      flash[:notice] = "アカウント復旧メールを送信しました。"
      redirect_to restoration_user_path
    else
      flash[:alert] = "このアカウントは退会しておりません。"
      redirect_to new_user_session_path
    end
  end

  def reregistration
    @user.update(is_deleted: false)
    flash[:notice] = "アカウント復旧が完了しました。ログインをお願いいたします。"
    redirect_to new_user_session_path
  end

    private

    def set_user
      @user = User.find(params[:id])
    end

    # ゲストユーザーの更新・削除不可
    def withdrawal_forbid_guest_user
      if @user.email == "guest@example.com"
        flash[:alert] = "ゲストユーザーの退会処理はできません。"
        redirect_to root_path
      end
    end
end
