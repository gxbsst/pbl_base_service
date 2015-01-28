class CreateTodosRecipients < ActiveRecord::Migration
  def change
    create_table :todos_recipients, id: :uuid do |t|
      t.uuid :todo_id
      t.uuid :assignee_id
      t.string :assignee_type

      t.timestamps
    end

    add_index :todos_recipients, [:assignee_type, :assignee_id]
    add_index :todos_recipients, :todo_id
  end
end
