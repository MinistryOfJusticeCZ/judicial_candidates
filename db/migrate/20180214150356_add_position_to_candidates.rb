class AddPositionToCandidates < ActiveRecord::Migration[5.1]
  def up
    add_column :candidates, :position, :integer
    Candidate.order(:updated_at).group_by{|can| can.state}.each do |state, items|
      items.each.with_index(1) do |todo_item, index|
        todo_item.update_column :position, index
      end
    end
  end

  def down
    remove_column :candidates, :position
  end
end
