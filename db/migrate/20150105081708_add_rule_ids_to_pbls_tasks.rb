class AddRuleIdsToPblsTasks < ActiveRecord::Migration
  def change
    add_column :pbls_tasks, :rule_ids, :text, array: true, default: []
  end
end
