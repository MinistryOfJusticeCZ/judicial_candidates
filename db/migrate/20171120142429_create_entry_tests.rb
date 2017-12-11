class CreateEntryTests < ActiveRecord::Migration[5.1]
  def change
    create_table :entry_tests do |t|
      t.datetime :time
      t.integer :capacity
      t.integer :place
      t.integer :points
      t.string  :state

      t.timestamps
    end
  end
end
