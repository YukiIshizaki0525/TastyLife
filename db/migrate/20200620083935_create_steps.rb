class CreateSteps < ActiveRecord::Migration[6.0]
  def change
    create_table :steps do |t|
      t.references :recipe, null: false, foreign_key: true
      t.text :direction, null: false

      t.timestamps
    end
  end
end
