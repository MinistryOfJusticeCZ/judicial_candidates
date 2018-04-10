class AddAdditionalInfoToEntryTests < ActiveRecord::Migration[5.1]
  def change
    add_column :entry_tests, :additional_info, :text
  end
end
