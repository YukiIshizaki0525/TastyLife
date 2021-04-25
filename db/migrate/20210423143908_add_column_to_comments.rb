class AddColumnToComments < ActiveRecord::Migration[6.0]
  def change
    add_column :comments, :reply_comment, :integer
  end
end
