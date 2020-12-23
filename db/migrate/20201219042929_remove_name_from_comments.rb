class RemoveNameFromComments < ActiveRecord::Migration[6.0]
  def change
    remove_column :comments, :name, :string
  end
end
