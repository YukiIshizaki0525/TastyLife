class ChangeDataQuantityToInventory < ActiveRecord::Migration[6.0]
  def change
    change_column :inventories, :quantity, :string
  end
end
