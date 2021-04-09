class AddFavoritesCountToRecipes < ActiveRecord::Migration[6.0]
  def self.up
    add_column :recipes, :favorites_count, :integer, null: false, default: 0
  end

  def self.down
    remove_column :recipes, :favorites_count
  end
end
