class AddUserIdToAssignmentsScores < ActiveRecord::Migration
  def change
    add_column :assignments_scores, :user_id, :uuid
    add_index :assignments_scores, :user_id
  end
end
