class RecipesController < ApplicationController
  before_action :set_recipe, only: [:show, :edit, :update, :destroy]

  def index
    @recipes = Recipe.all
  end

  def show
    @comments = @recipe.comments
    @comment = current_user.comments.new #=> formのパラメータ用にCommentオブジェクトを取得
  end

  def new
    @recipe = Recipe.new(flash[:recipe])
    @comment = current_user.comments.new
  end

  def edit
  end

  def create
    recipe = current_user.recipes.new(recipe_params)
    recipe.image.attach(params[:recipe][:image])

    if recipe.save
      redirect_to recipe, flash: { notice: "「#{recipe.title}」のレシピを投稿しました。" }
    else
      redirect_to new_recipe_path, flash: {
        recipe: recipe,
        error_messages: recipe.errors.full_messages
      }
    end
  end

  def update
    @recipe.update(recipe_params)
    if @recipe.save
      redirect_to @recipe, flash: { notice: "「#{@recipe.title}」のレシピを更新しました。" }
    else
      flash[:recipe] = @recipe
      flash[:error_messages] = @recipe.errors.full_messages
      redirect_back fallback_location: @recipe
    end
  end

  def destroy
    @recipe.destroy
    redirect_to recipes_path, flash: { notice: "「#{@recipe.title}」のレシピを削除しました。" }
  end
  
  private
    def set_recipe
      @recipe = Recipe.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def recipe_params
      params.require(:recipe).permit(:image, :title, :description, :user_id,
        ingredients_attributes: [:id, :content, :quantity, :_destroy],
        steps_attributes: [:id, :direction, :step_image, :_destroy])
    end
end 
