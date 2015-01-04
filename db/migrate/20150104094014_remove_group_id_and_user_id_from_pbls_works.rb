class RemoveGroupIdAndUserIdFromPblsWorks < ActiveRecord::Migration
  def up
    remove_column :pbls_works, :group_id
    remove_column :pbls_works, :user_id
  end

  def down
    add_column :pbls_works, :group_id, :uuid
    add_column :pbls_works, :user_id, :uuid
  end

end
