class AddLableAndCoverIdToGroupsGroups < ActiveRecord::Migration
  def change
    add_column :groups_groups, :label, :text, array: true, default: []
    add_column :groups_groups, :cover_id, :uuid
  end
end
