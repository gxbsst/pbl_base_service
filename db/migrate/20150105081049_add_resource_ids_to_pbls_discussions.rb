class AddResourceIdsToPblsDiscussions < ActiveRecord::Migration
  def change
    add_column :pbls_discussions, :resource_ids, :text, array: true, default: []
  end
end
