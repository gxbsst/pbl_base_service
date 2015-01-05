class ChangeColumnNameInAssignmentsWorks < ActiveRecord::Migration

  def change
    remove_column :assignments_works, :task_id, :string

    rename_column :assignments_works, :assignee_id, :sender_id
    rename_column :assignments_works, :owner_id, :task_id
    rename_column :assignments_works, :owner_type, :task_type

    add_column :assignments_works, :acceptor_type, :string
    add_column :assignments_works, :acceptor_id, :uuid

    add_index :assignments_works, [:acceptor_type]
    add_index :assignments_works, [:acceptor_id]
    add_index :assignments_works, [:sender_id]
    add_index :assignments_works, [:task_id, :task_type]
  end
end
