class CreatePblsTasks < ActiveRecord::Migration
  def change
    create_table :pbls_tasks do |t|
      t.uuid :project_id, index: true
      t.string :title
      t.text :description
      t.string :teacher_tools
      t.string :student_tools
      t.string :task_type
      t.uuid :discipline_id, index: true
      t.integer :evaluation_duration
      t.integer :evaluation_cycle
      t.integer :product_id, index: true
      t.integer :event_duration
      t.integer :event_cycle

      t.timestamps
    end
  end
end
