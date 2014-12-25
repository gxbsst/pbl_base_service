class AddMembersCountToGroup < ActiveRecord::Migration
  def change
    add_column :groups_groups, :members_count, :integer, default: 0
  end
end
