class CreateCandidateEntryTests < ActiveRecord::Migration[5.1]
  def change
    create_table :candidate_entry_tests do |t|
      t.references :candidate, foreign_key: true, index: true
      t.references :entry_test, foreign_key: true, index: true
      t.integer :points
      t.integer :arrival, default: 1, null: false
      t.text :apology

      t.timestamps
    end
  end
end
