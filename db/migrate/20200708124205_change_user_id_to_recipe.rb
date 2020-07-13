class ChangeUserIdToRecipe < ActiveRecord::Migration[6.0]
  def change
    change_column_null :recipes, :user_id, null: false
  end
end
