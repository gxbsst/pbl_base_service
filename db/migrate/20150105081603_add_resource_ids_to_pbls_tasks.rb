class AddResourceIdsToPblsTasks < ActiveRecord::Migration
  def change
    add_column :pbls_tasks, :resource_ids, :text, array: true, default: []
  end
end
