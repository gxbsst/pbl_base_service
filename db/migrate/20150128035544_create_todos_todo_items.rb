class CreateTodosTodoItems < ActiveRecord::Migration
  def change
    create_table :todos_todo_items, id: :uuid do |t|
      t.uuid :todo_id
      t.uuid :user_id
      t.string :state
      t.uuid :recipient_id

      t.timestamps
    end

    add_index :todos_todo_items, :user_id
    add_index :todos_todo_items, :todo_id
    add_index :todos_todo_items, :recipient_id
  end
end
