class RecipesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :create, :update, :destroy]
  before_action :set_recipe, only: [:show, :edit, :update, :destroy]
  before_action :set_q, only: [:index, :search]

  def index
    @title = "レシピ一覧"
    @recipes = params[:tag_id].present? ? Tag.find(params[:tag_id]).recipes : Recipe

    if user_signed_in?
      @recipes = @recipes.includes([:user], [:favorites]).page(params[:page]).per(6)
    else
      @recipes = @recipes.includes([:user]).page(params[:page]).per(6)
    end
  end

  def show
    @title = "#{@recipe.title}"
    @comments = Comment.includes([:user]).where(recipe_id: @recipe.id)

    if user_signed_in?
      @comment = current_user.comments.new(flash[:comment])
      @comment_reply = current_user.comments.new
    end
  end

  def new
    @recipe = Recipe.new(flash[:recipe])
  end

  def edit
    @title = "#{@recipe.title}の編集"
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
  
  def search
    if user_signed_in?
      @recipes = @q.result(distinct: true).includes([:favorites]).page(params[:page]).per(6)
    else
      @recipes = @q.result(distinct: true).includes([:user]).page(params[:page]).per(6)
    end
    @search = params[:q][:title_or_ingredients_content_cont]
  end
  
  def tag_search
    @tag = Tag.find(params[:tag_id])
    @recipes = @tag.recipes.includes([:user], [:favorites])
  end
  
  private
    def set_recipe
      @recipe = Recipe.find(params[:id])
    end

    def set_q
      @q = Recipe.ransack(params[:q])
    end

    # Only allow a list of trusted parameters through.
    def recipe_params
      params.require(:recipe).permit(
        :image,
        :image_cache,
        :remove_image,
        :title,
        :description,
        :user_id,
        :keyword,
        tag_ids: [],
        ingredients_attributes: [:id, :content, :quantity, :_destroy],
        steps_attributes: [:id, :direction, :image, :_destroy]
      )
    end
  end