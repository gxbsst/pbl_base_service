json.data do
  json.array! @users
end

json.meta do
  json.total_count @users.count
  json.total_pages @users.total_pages
  json.current_page @users.current_page
  json.per_page @limit
end
