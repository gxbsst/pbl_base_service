class AddUserIdToResources < ActiveRecord::Migration
  def change
    add_column :resources, :user_id, :uuid
    add_index :resources, :user_id
  end
end
