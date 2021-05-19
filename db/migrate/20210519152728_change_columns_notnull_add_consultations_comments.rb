class ChangeColumnsNotnullAddConsultationsComments < ActiveRecord::Migration[6.0]
  def change
    change_column :consultation_comments, :content, :text, null: false
  end
end
