class AddContentAndResourceIdToAssignmentsWorks < ActiveRecord::Migration
  def change
    add_column :assignments_works, :content, :text
    add_column :assignments_works, :resource_id, :uuid
  end
end
