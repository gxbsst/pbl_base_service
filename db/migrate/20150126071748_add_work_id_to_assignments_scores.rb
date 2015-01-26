class AddWorkIdToAssignmentsScores < ActiveRecord::Migration
  def change
    add_column :assignments_scores, :work_id, :uuid
  end
end
