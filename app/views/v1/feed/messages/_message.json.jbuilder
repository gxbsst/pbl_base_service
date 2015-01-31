json.extract! message,
              :id,
              :user_id,
              :sender_id,
              :post_id,
              :created_at,
              :updated_at
json.post do
  json.partial! 'v1/feed/posts/post', post: message.post
end


