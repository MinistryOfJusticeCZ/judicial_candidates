class CreateCandidateInterviews < ActiveRecord::Migration[5.1]
  def change
    create_table :candidate_interviews do |t|
      t.references :candidate, foreign_key: true, null: false
      t.references :interview, foreign_key: true, null: false
      t.string :state
      t.text :apology

      t.timestamps
    end
  end
end
