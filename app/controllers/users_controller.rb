class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :following, :followers, :consultations]
  before_action :set_user, only: [:show , :destroy, :following, :followers, :consultations, :inventories]
  def index
    @users = User.page(params[:page]).per(6)
  end

  def show
    @recipes = @user.recipes.page(params[:page]).per(6)
  end

  def destroy
    @user.destroy
    redirect_to users_url, flash: { success: "「#{@user.name}を削除しました」"}
  end

  def following
    @title = "Following"
    @users = @user.following.page(params[:page]).per(6)
    render 'show_follow'
  end


  def followers
    @title = "Followers"
    @users = @user.followers.page(params[:page]).per(6)
    render 'show_follow'
  end

  def consultations
    @title = "Consultation"
    @consultations = @user.consultations.page(params[:page]).per(3)
    render 'show_consultation'
  end

  def inventories
    @title = "Inventory"
    @inventories = @user.inventories.page(params[:page]).order(expiration_date: 'ASC').per(6)
    render 'show_inventory'
  end

    private

    def set_user
      @user = User.find(params[:id])
    end
end
