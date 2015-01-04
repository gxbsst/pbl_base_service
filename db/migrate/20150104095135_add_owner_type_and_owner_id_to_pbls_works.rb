class AddOwnerTypeAndOwnerIdToPblsWorks < ActiveRecord::Migration
  def change
    add_column :pbls_works, :owner_id, :uuid
    add_column :pbls_works, :owner_type, :string
    add_column :pbls_works, :task_id, :uuid

    add_index :pbls_works, [:owner_id, :owner_type, :task_id]
  end
end
