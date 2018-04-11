class AddTitleToCandidates < ActiveRecord::Migration[5.1]
  def change
    add_column :candidates, :title, :string
  end
end
