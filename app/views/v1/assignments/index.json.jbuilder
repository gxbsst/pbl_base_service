json.data do
  json.array! @collections do |collect|
    json.id collect.id
    json.user_id collect.user_id
    json.role_id collect.role_id
    json.user do
      json.partial! 'v1/users/user', user: collect.user
    end
  end
end

json.meta do
  json.total_count @collections.count
  json.total_pages @collections.total_pages
  json.current_page @collections.current_page
  json.per_page @limit
end
