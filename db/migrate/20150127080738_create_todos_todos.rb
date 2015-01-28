class CreateTodosTodos < ActiveRecord::Migration
  def change
    create_table :todos_todos, id: :uuid do |t|
      t.datetime :start_at
      t.datetime :end_at
      t.string :repeat_by
      t.text :content
      t.string :state
      t.uuid :user_id

      t.timestamps
    end

    add_index :todos_todos, :repeat_by
    add_index :todos_todos, :user_id
    add_index :todos_todos, :state
  end
end
