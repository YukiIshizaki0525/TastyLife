class AddIndexRecipesUserId < ActiveRecord::Migration[6.0]
  def change
    add_index :recipes, [:user_id, :created_at]
  end
end
