json.extract! message,
              :id,
              :user_id,
              :sender_id,
              :post_id
json.post do
  json.partial! 'v1/feed/posts/post', post: message.post
end


