class UsersController < ApplicationController
  before_action :set_user, only: [:show , :destroy, :following, :followers]
  def index
    @users = User.page(params[:page]).per(6)
  end

  def show
    @recipes = @user.recipes.page(params[:page])
  end

  def destroy
    @user.destroy
    redirect_to users_url, flash: { success: "「#{@user.name}を削除しました」"}
  end

  def following
    @title = "Following"
    @users = @user.following.page(params[:page])
    render 'show_follow'
  end


  def followers
    @title = "Followers"
    @users = @user.followers.page(params[:page])
    render 'show_follow'
  end

    private

    def set_user
      @user  = User.find(params[:id])
    end
end
