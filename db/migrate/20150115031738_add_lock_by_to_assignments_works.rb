class AddLockByToAssignmentsWorks < ActiveRecord::Migration
  def change
    add_column :assignments_works, :lock_by, :uuid

    add_index :assignments_works, :lock_by
  end
end
