class CreateInterviews < ActiveRecord::Migration[5.1]
  def change
    create_table :interviews do |t|
      t.datetime :time
      t.references :region_court, foreign_key: false
      t.references :address, foreign_key: {to_table: :egov_utils_addresses}
      t.integer :boundary
      t.datetime :compensatory

      t.timestamps
    end
  end
end
