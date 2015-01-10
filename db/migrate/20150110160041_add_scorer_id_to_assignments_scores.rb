class AddScorerIdToAssignmentsScores < ActiveRecord::Migration
  def change
    add_column :assignments_scores, :scorer_id, :uuid
    add_index :assignments_scores, :scorer_id
  end
end
