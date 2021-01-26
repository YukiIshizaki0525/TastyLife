class RecipesTag
  has_one_attached :image
  include ActiveModel::Model
  attr_accessor :title, :description, :user_id, :name, :image

  with_options presence: true do
    validates :title
    validates :description
    validates :name
  end

  # レシピ完成イメージの画像
  

  def save
    recipe = Recipe.create(title: title, description: description, user_id: user_id, image: image)
    tag = Tag.where(name: name).first_or_initialize
    tag.save
    RecipeTagRelation.create(recipe_id: recipe.id, tag_id: tag.id)
  end

end