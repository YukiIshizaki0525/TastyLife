class ChangeConsultationInterestsToInterests < ActiveRecord::Migration[6.0]
  def change
    rename_table :consultation_interests, :interests
  end
end
