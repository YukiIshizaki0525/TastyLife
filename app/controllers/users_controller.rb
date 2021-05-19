class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:destroy, :inventories]
  before_action :set_user, only: [:show , :destroy, :following, :followers, :consultations, :favorites, :interests, :inventories]
  def index
    @users = User.includes([:recipes], [avatar_attachment: :blob]).page(params[:page]).per(6).order(id: :ASC)
  end

  def show
    @recipes = @user.recipes.includes([:favorites], [image_attachment: :blob]).page(params[:page]).per(6)
  end

  def destroy
    @user.destroy
    redirect_to users_url, success: "「#{@user.name}を削除しました」"
  end

  def following
    @title = "さんがフォロー中"
    @message = "まだ誰もフォローしていません。"
    @users = @user.following.includes([:recipes], [avatar_attachment: :blob]).page(params[:page]).per(6)
    render 'show_follow'
  end


  def followers
    @title = "さんのフォロワー"
    @message = "まだ誰からもフォローされていません。"
    @users = @user.followers.includes([:recipes], [avatar_attachment: :blob]).page(params[:page]).per(6)
    render 'show_follow'
  end

  def consultations
    @title = "Consultation"
    @consultations = @user.consultations.includes([:consultation_comments], [:interests]).page(params[:page]).per(3)
    render 'show_consultation'
  end

  def favorites
    @title = "Favorite"
    @recipes = @user.favorite_recipes.includes([user: { avatar_attachment: :blob }], [:favorites], [image_attachment: :blob]).page(params[:page]).per(6)
    render 'show_favorite'
  end

  def interests
    @title = "Interest"
    @consultations = @user.interest_consultations.includes([user: { avatar_attachment: :blob }], [:interests]).page(params[:page]).per(6)
    render 'show_interest'
  end

  def inventories
    if user_signed_in? && @user.id == current_user.id
      @title = "Inventory"
      @inventories = @user.inventories.includes([photo_attachment: :blob]).page(params[:page]).order(expiration_date: 'ASC').per(6)
      render 'show_inventory'
    else
      flash[:alert] = "他人の食材管理ページ閲覧及び編集はできません。"
      redirect_to root_path
    end
    
  end

    private

    def set_user
      @user = User.find(params[:id])
    end
end
