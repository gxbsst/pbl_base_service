json.data do
  json.array! @categories
end

json.meta do
  json.total_count @categories.count
  json.total_pages @categories.total_pages
  json.current_page @categories.current_page
  json.per_page @limit
end