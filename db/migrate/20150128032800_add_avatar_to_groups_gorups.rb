class AddAvatarToGroupsGorups < ActiveRecord::Migration
  def change
    add_column :groups_groups, :avatar, :string
  end
end
