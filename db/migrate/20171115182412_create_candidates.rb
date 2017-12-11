class CreateCandidates < ActiveRecord::Migration[5.1]
  def change
    create_table :candidates do |t|
      t.references :user, foreign_key: {to_table: :egov_utils_users}
      t.integer :state, default: 0
      t.date :birth_date
      t.string :phone
      t.integer :university
      t.integer :graduation_year
      t.string :higher_title
      t.string :organizations, array: true, default: [] # TOTHINK this row lock to PG
      t.string :suborganizations, array: true, default: []
      t.string :diploma_uid
      t.boolean :shorter_invitation
      t.boolean :agreed_limitations

      t.timestamps
    end
  end
end
