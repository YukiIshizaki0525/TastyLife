class AddImageToInventories < ActiveRecord::Migration[6.0]
  def change
    add_column :inventories, :image, :string
  end
end
