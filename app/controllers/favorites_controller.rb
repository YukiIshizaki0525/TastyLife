class FavoritesController < ApplicationController
  before_action :recipe_params
  def create
    current_user.favorites.create(recipe_id: @recipe.id)
  end

  def destroy
    current_user.favorites.find_by(recipe_id: @recipe.id).destroy
  end

  def recipe_params
    @recipe = Recipe.find(params[:recipe_id])
  end
end
