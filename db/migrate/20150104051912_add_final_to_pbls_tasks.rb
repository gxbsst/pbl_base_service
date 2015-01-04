class AddFinalToPblsTasks < ActiveRecord::Migration
  def change
    add_column :pbls_tasks, :final, :boolean, default: false
  end
end
