class RenameWorkIdAndAddOwnerTypeToAssignmentsScores < ActiveRecord::Migration
  def change
    rename_column :assignments_scores, :work_id, :owner_id
    add_column :assignments_scores, :owner_type, :string

    add_index :assignments_scores, :owner_type
  end
end
