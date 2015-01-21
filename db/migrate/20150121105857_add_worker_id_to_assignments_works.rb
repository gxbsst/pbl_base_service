class AddWorkerIdToAssignmentsWorks < ActiveRecord::Migration
  def change
    add_column :assignments_works, :worker_id, :uuid
  end
end
