class RemoveCoverIdInGroupsGorups < ActiveRecord::Migration
  def change
    remove_column :groups_groups, :cover_id
  end
end
