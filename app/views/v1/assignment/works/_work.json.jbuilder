json.extract! work, :id, :sender_id, :task_id, :task_type, :acceptor_id, :acceptor_type, :state, :content, :resource_id, :submit_at
if @include_scores
  json.scores do
    json.array! work.scores
  end
end
