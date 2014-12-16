class AddIdToUsersRoles < ActiveRecord::Migration
  def change
    add_column :users_roles, :id, :uuid, index: true
  end
end
