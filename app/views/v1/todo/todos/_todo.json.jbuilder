json.extract! todo,
              :id,
              :content,
              :user_id,
              :start_at,
              :end_at,
              :repeat_by,
              :state,
              :updated_at,
              :created_at

json.recipients do
  json.array! todo.recipients
end

