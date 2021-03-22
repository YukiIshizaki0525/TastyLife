class RecipesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :tag_search]
  before_action :set_recipe, only: [:show, :edit, :update, :destroy]

  def index
    @recipes = params[:tag_id].present? ? Tag.find(params[:tag_id]).recipes : Recipe.all
    @recipes = @recipes.page(params[:page]).per(6)
  end

  def show
    @comments = @recipe.comments
    if user_signed_in?
      @comment = current_user.comments.new #=> formのパラメータ用にCommentオブジェクトを取得
    end
  end

  def new
    @recipe = Recipe.new(flash[:recipe])
    @comment = current_user.comments.new
  end

  def edit
    if @recipe.user == current_user
      render "edit"
    else
      redirect_back fallback_location: root_path, flash: { alert: "他人のレシピは編集できません" }
    end
  end

  def create
    recipe = current_user.recipes.new(recipe_params)

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
    redirect_to user_path(current_user.id), flash: { notice: "「#{@recipe.title}」のレシピを削除しました。" }
  end

  def tag_search
    @tag = Tag.find(params[:tag_id])
    @recipes = @tag.recipes
  end

  private
    def set_recipe
      @recipe = Recipe.find(params[:id])
      # redirect_to(root_url) unless current_user.id == @consultation.user_id
    end

    # Only allow a list of trusted parameters through.
    def recipe_params
      params.require(:recipe).permit(
        :recipe_image,
        :remove_recipe_image,
        :title,
        :description,
        :user_id,
        tag_ids: [],
        ingredients_attributes: [:id, :content, :quantity, :_destroy],
        steps_attributes: [:id, :direction, :step_image, :_destroy])
    end
end