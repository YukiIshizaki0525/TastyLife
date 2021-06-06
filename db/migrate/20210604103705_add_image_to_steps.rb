class AddImageToSteps < ActiveRecord::Migration[6.0]
  def change
    add_column :steps, :image, :string
  end
end
