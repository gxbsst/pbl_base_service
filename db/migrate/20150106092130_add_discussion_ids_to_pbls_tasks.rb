class AddDiscussionIdsToPblsTasks < ActiveRecord::Migration
  def change
    add_column :pbls_tasks, :discussion_ids, :text, array: true, default: []
  end
end
