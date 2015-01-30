json.extract! todo_item,
              :id,
              :content,
              :user_id,
              :start_at,
              :end_at,
              :repeat_by,
              :state

json.recipients do
  json.array! todo_item.todo.recipients
end
