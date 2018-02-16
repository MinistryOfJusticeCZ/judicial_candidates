class AddUniqueIndexForCandidateEntryTest < ActiveRecord::Migration[5.1]
  def change
    add_index :candidate_entry_tests, [:candidate_id, :entry_test_id], unique: true
  end
end
