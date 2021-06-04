class RecipesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :tag_search]
  before_action :set_recipe, only: [:show, :edit, :update, :destroy]
  before_action :set_q, only: [:index, :search]

  def index
    @recipes = params[:tag_id].present? ? Tag.find(params[:tag_id]).recipes : Recipe
    @recipes = @recipes.includes([:favorites], [user: { avatar_attachment: :blob }], [image_attachment: :blob]).page(params[:page]).per(6)
  end

  def show
    @recipe = Recipe.includes([steps: { step_image_attachment: :blob }]).find(params[:id])
    @comments = Comment.includes([user: { avatar_attachment: :blob }]).where(recipe_id: @recipe.id)

    if user_signed_in?
      @comment = current_user.comments.new(flash[:comment])
      @comment_reply = current_user.comments.new(flash[:comment_reply])
    end
  end

  def new
    @recipe = Recipe.new(flash[:recipe])
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
  
  def search
    @recipes = @q.result(distinct: true).includes([:favorites], [user: { avatar_attachment: :blob }], [image_attachment: :blob]).page(params[:page]).per(6)
    @search = params[:q][:title_or_ingredients_content_cont]
  end
  
  def tag_search
    @tag = Tag.find(params[:tag_id])
    @recipes = @tag.recipes
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
        :title,
        :description,
        :user_id,
        :keyword,
        tag_ids: [],
        ingredients_attributes: [:id, :content, :quantity, :_destroy],
        steps_attributes: [:id, :direction, :step_image, :_destroy]
      )
    end
  end