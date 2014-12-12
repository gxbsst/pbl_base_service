json.data do
  json.array! @projects
end

json.meta do
  json.total_count @projects.count
  json.total_pages @projects.total_pages
  json.current_page @projects.current_page
  json.per_page @limit
end
