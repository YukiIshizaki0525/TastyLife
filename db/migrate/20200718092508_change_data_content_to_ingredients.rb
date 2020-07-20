class ChangeDataContentToIngredients < ActiveRecord::Migration[6.0]
  def change
    change_column :ingredients, :content, :string
  end
end
