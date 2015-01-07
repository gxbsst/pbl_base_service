class AddSubmitAtToAssignmentsWorks < ActiveRecord::Migration
  def change
    add_column :assignments_works, :submit_at, :datetime
  end
end
