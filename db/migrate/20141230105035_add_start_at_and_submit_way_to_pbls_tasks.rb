class AddStartAtAndSubmitWayToPblsTasks < ActiveRecord::Migration
  def change
    add_column :pbls_tasks, :start_at, :datetime
    add_column :pbls_tasks, :submit_way, :string
  end
end
