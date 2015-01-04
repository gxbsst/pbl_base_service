class AddOwnerTypeAndOwnerIdToGroupsGroups < ActiveRecord::Migration
  def change
    add_column :groups_groups, :owner_type, :string
    add_column :groups_groups, :owner_id, :uuid
    remove_column :groups_groups, :user_id

    add_index :groups_groups, [:owner_id, :owner_type]
  end

end
