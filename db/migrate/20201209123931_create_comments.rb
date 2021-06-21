class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.references :recipe, null: false, foreign_key: true
      t.text :content, null: false
      t.integer :comments, :reply_comment

      t.timestamps
    end
  end
end
