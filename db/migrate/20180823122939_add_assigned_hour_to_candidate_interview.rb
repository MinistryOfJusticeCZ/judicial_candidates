class AddAssignedHourToCandidateInterview < ActiveRecord::Migration[5.1]
  def change
    add_column :candidate_interviews, :assigned_hour, :time
  end
end
