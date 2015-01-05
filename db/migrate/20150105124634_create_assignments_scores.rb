class CreateAssignmentsScores < ActiveRecord::Migration
  def change
    create_table :assignments_scores, id: :uuid do |t|
      t.uuid :work_id
      t.integer :score
      t.text :comment

      t.timestamps
    end

    add_index :assignments_scores, :work_id
  end
end
