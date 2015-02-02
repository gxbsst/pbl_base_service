json.extract! todo_item,
              :id,
              :content,
              :user_id,
              :start_at,
              :end_at,
              :repeat_by,
              :state,
              :sender_id,
              :created_at,
              :updated_at

json.recipients do
  json.array! todo_item.todo.recipients
end
