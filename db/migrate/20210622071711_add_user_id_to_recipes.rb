class AddUserIdToRecipes < ActiveRecord::Migration[6.0]
  def change
    add_reference :recipes, :user, foreign_key: true, null: false
  end
end
