class RemoveUidInPblsDiscussions < ActiveRecord::Migration
  def change
    remove_column :pbls_discussions, :uid
    add_column :pbls_discussions, :no, :integer
  end
end
