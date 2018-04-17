class AddParanoidToEntryTestAndInterview < ActiveRecord::Migration[5.1]
  def change
    add_column :entry_tests, :deleted_at, :datetime
    add_column :interviews, :deleted_at, :datetime
    add_index :entry_tests, :deleted_at
    add_index :interviews, :deleted_at
  end
end
