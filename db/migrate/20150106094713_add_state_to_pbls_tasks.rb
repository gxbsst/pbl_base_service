class AddStateToPblsTasks < ActiveRecord::Migration
  def change
    add_column :pbls_tasks, :state, :string

    add_index :pbls_tasks, :state
  end
end
