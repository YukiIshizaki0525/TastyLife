class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @recipes = @user.recipes.page(params[:page])
  end
end
