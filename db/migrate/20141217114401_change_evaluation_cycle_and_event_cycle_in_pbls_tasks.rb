class ChangeEvaluationCycleAndEventCycleInPblsTasks < ActiveRecord::Migration
  def change
    change_column :pbls_tasks, :evaluation_cycle, :string
    change_column :pbls_tasks, :event_cycle, :string
  end
end
