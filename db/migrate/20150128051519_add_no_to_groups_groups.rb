class AddNoToGroupsGroups < ActiveRecord::Migration
  def change
    add_column :groups_groups, :no, :integer
  end
end
