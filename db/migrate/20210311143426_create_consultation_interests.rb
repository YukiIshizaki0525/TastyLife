class CreateConsultationInterests < ActiveRecord::Migration[6.0]
  def change
    create_table :consultation_interests do |t|
      t.references :user, null: false, foreign_key: true
      t.references :consultation, null: false, foreign_key: true

      t.timestamps
    end
  end
end
